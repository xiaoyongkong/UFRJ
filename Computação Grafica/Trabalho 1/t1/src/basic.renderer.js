(function (global, factory) {
	typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
	typeof define === 'function' && define.amd ? define(['exports'], factory) :
	(global = global || self, factory(global.BasicRenderer = {}));
}(this, (function (exports) { 'use strict';

    //Function to calculate max and min
    function arrayMin(arr) {
        return arr.reduce(function (p, v) {
            return ( p < v ? p : v );
        });
    }    
    function arrayMax(arr) {
        return arr.reduce(function (p, v) {
            return ( p > v ? p : v );
        });
    }

    //Create Bounding Box
    function createBoundingBox(primitive){
        var x_0 = 0;
        var x_1 = 0;
        var y_0 = 0;
        var y_1 = 0;
        var coord_box = [];

        if(primitive.shape == "triangle"){
            var V = primitive.vertices;
            var eixos = V[0].length;
            var pontos = V.length;
            var coord_x = [];
            var coord_y = []; 

            //0 begins
            //1 ends
            for(var i=0;i<pontos;i++){
                for(var j=0;j<eixos;j++){
                    
                    if(j==0){
                        coord_x.push(V[i][j]);
                    }else{
                        coord_y.push(V[i][j]);
                    } 
                }
            }
            x_0 = arrayMin(coord_x); 
            x_1 = arrayMax(coord_x);
            y_0 = arrayMin(coord_y);
            y_1 = arrayMax(coord_y);               
        }
        coord_box = {  
            x_0: x_0,
            x_1: x_1,
            y_0: y_0,
            y_1: y_1, 
        }
        return coord_box;
    }
    //calculate Normal
    function vNormal(A, B){
        var N = [-1*(B[1]-A[1]), (B[0] - A[0])];        
        return N;
    }   

    //Inspect (x,y) in primitive
    function inside( x, y, primitive  ) {
            // You should implement your inside test here for all shapes   
            // for now, it only returns a false test                                   
            if(primitive.shape == "triangle"){
                var V = primitive.vertices;
                var P0 = [V[0][0], V[0][1]];
                var P1 = [V[1][0], V[1][1]];
                var P2 = [V[2][0], V[2][1]];

                var n0 = vNormal(P0, P1);
                var n1 = vNormal(P1, P2);
                var n2 = vNormal(P2, P0);

                var d0 = [x - P0[0], y - P0[1] ];
                var d1 = [x - P1[0], y - P1[1] ];
                var d2 = [x - P2[0], y - P2[1] ];

                var L0 = (d0[0] * n0[0]) + (d0[1] * n0[1]);
                var L1 = (d1[0] * n1[0]) + (d1[1] * n1[1]);
                var L2 = (d2[0] * n2[0]) + (d2[1] * n2[1]);

                if(L0>0 && L1>0 && L2>0){                    
                    return true;
                }
            }
            else{
                return false;
            }
    }
    
    function Screen( width, height, scene ) {
        this.width = width;
        this.height = height;
        this.scene = this.preprocess(scene);   
        this.createImage(); 
    }


    function toRadians(a){
        var resultado = (a*Math.PI)/180;
        return resultado;
    }

    //convert poligon primitive to trinagles
    function toTriangles(preprop_scene, primitive ){        

        var V = primitive.vertices;
        var pontos = V.length;
        var P0 = [V[0][0], V[0][1]];

        for(var k=1; k < pontos-1 ; k++){
            
            var triangulo = {
                shape:"triangle",
                vertices: [
                    [P0[0], P0[1]],
                    [V[k][0], V[k][1]],
                    [V[k+1][0], V[k+1][1]]
                ],
                color: primitive.color,   
            };
            var boundingBox = createBoundingBox(triangulo);
            preprop_scene.push( boundingBox );
            preprop_scene.push( triangulo );                            
        }  
        return preprop_scene;
    }

    Object.assign( Screen.prototype, {

            preprocess: function(scene) {
                var preprop_scene = [];
                
                for( var primitive of scene ) {  
                    
                    if(primitive.shape == "polygon" ){

                        primitive.vertices = primitive.vertices.tolist();
                        preprop_scene = toTriangles(preprop_scene, primitive);
                 
                    }if(primitive.shape == "circle") {

                        var r = primitive.radius;
                        var h = primitive.center.get(0);
                        var k = primitive.center.get(1);
                        
                        var numLados = 20;
                        var numVertices = numLados+2;

                        var P0 = [h ,k];                        
                        var Vertices = []; 
                        Vertices.push(P0);     
                                        
                        var alpha = 360/numLados; 
                        var theta = 0;
                        
                        for(var i = 0; i < numVertices ; i++){            
                            theta = (alpha*i); 
                            var x = Math.floor((r * Math.cos(toRadians(theta))) + h);
                            var y = Math.floor((r * Math.sin(toRadians(theta))) + k);
                            var P = [x,y];
                            Vertices.push(P);                           

                        }
                        //creating new primitive
                        var polygon = {
                            shape:"polygon", 
                            vertices: Vertices,
                            color: primitive.color,   
                        };
                        preprop_scene = toTriangles(preprop_scene, polygon);                      
                        
                    } 
                    if(primitive.shape == "triangle"){
                        primitive.vertices = primitive.vertices.tolist();
                         
                        var boundingBox = createBoundingBox(primitive);            
                        preprop_scene.push( boundingBox );
                        
                        preprop_scene.push( primitive );
                    }              
                }
                return preprop_scene;
            },

            createImage: function() {
                this.image = nj.ones([this.height, this.width, 3]).multiply(255);
            },

            rasterize: function() {
                var color;
                
                //runs based on bounding box and his primitive
                for(var k=0; k<this.scene.length; k=k+2){
                    var bbox = this.scene[k];
                    var primitive = this.scene[k+1];
                    
                    for (var i = bbox.x_0; i <= bbox.x_1; i++) {
                        var x = i + 0.5;
                        for( var j = bbox.y_0; j <= bbox.y_1; j++) {
                            var y = j + 0.5;                            
                            if ( inside( x, y, primitive ) ) {                                
                                color = primitive.color;
                                this.set_pixel( i, this.height - (j + 1), color );
                            }
                        }
                    }                 
                }              
            },

            set_pixel: function( i, j, colorarr ) {
                // We assume that every shape has solid color
                this.image.set(j, i, 0, colorarr.get(0));
                this.image.set(j, i, 1, colorarr.get(1));
                this.image.set(j, i, 2, colorarr.get(2));
            },

            update: function () {
                // Loading HTML element
                var $image = document.getElementById('raster_image');
                $image.width = this.width; $image.height = this.height;

                // Saving the image
                nj.images.save( this.image, $image );
            }
        }
    );

    exports.Screen = Screen;
    
})));

