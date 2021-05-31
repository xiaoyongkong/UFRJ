function WaveAnimation() {}

Object.assign( WaveAnimation.prototype, {

    init: function() {
        // This is an example of rotation of the right_upper_arm 
        // Notice that the transform is M = T * R 
        let right_upper_arm = robot.getObjectByName("right_upper_arm");
        let left_upper_arm = robot.getObjectByName("left_upper_arm");
        let right_lower_arm = right_upper_arm.getObjectByName("lower_arm");
        let left_lower_arm = left_upper_arm.getObjectByName("lower_arm");
        let right_hand = right_lower_arm.getObjectByName("hand");
        let left_hand = left_lower_arm.getObjectByName("hand");

        let hand_shake_angle = Math.PI/4;
        let head_tilt_angle = Math.PI/16;
        let arm_angle = Math.PI/2;
        let hand_shake_duration = 600;
        let head_tilt_duration = 1200;
        let upper_arm_duration = 500;

        let upperArmTween = new TWEEN.Tween( {theta:0} )
            .to( {theta:arm_angle }, upper_arm_duration)
            .onUpdate(function(){
                let pos_x = right_upper_arm.position.x;
                let pos_y = right_upper_arm.position.y;
                let offset = right_upper_arm.geometry.parameters.height/3.0;

                right_upper_arm.matrix.makeRotationZ(this._object.theta)
                    .premultiply(new THREE.Matrix4().makeTranslation(pos_x, pos_y + offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -offset, 0));
                
                // Updating final world matrix (with parent transforms) - mandatory
                right_upper_arm.updateMatrixWorld(true);

                stats.update();
                renderer.render(scene, camera);
            })


        let lowerArmTween = new TWEEN.Tween({theta:0})
            .to({ theta: arm_angle }, 2*upper_arm_duration)
            .onUpdate(function() {
                let pos_x = right_lower_arm.position.x;
                let pos_y = right_lower_arm.position.y;
                let offset = right_lower_arm.geometry.parameters.height/3.0;

                right_lower_arm.matrix
                    .makeRotationZ(this._object.theta)
                    .premultiply(new THREE.Matrix4().makeTranslation(pos_x, pos_y + offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -offset, 0))
                ;

                right_lower_arm.updateMatrixWorld(true);
                stats.update();
                renderer.render(scene, camera);
            });
            
        let pos_x = right_hand.position.x;
        let pos_y = right_hand.position.y;
        let offset = right_hand.geometry.parameters.height/2.0;

        let handTweenOne = new TWEEN.Tween({theta:0})
            .to({ theta: hand_shake_angle }, hand_shake_duration)
            .onUpdate(function() {
                right_hand.matrix.makeRotationZ(this._object.theta)
                    .premultiply(new THREE.Matrix4().makeTranslation(pos_x, pos_y + offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -offset, 0))

                right_hand.updateMatrixWorld(true);

                stats.update();
                renderer.render(scene, camera);
            });

        let handTweenTwo = new TWEEN.Tween({theta:hand_shake_angle})
            .to({ theta: -hand_shake_angle }, 2*hand_shake_duration)
            .onUpdate(function() {
                right_hand.matrix.makeRotationZ(this._object.theta)
                    .premultiply(new THREE.Matrix4().makeTranslation(pos_x, pos_y + offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -offset, 0))

                right_hand.updateMatrixWorld(true);

                stats.update();
                renderer.render(scene, camera);
            });

        let handTweenThree = new TWEEN.Tween({theta:-hand_shake_angle})
            .to({ theta: 0 }, hand_shake_duration)
            .onUpdate(function() {
                right_hand.matrix.makeRotationZ(this._object.theta)
                    .premultiply(new THREE.Matrix4().makeTranslation(pos_x, pos_y + offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -offset, 0))

                right_hand.updateMatrixWorld(true);

                stats.update();
                renderer.render(scene, camera);
            });

        let headTween = new TWEEN.Tween({theta:0})
            .to({ theta: head_tilt_angle}, head_tilt_duration)
            .onUpdate(function() {
                let head = robot.getObjectByName("head");
                let offset = 1.8;

                head.matrix.makeRotationZ(this._object.theta)
                    .premultiply(new THREE.Matrix4().makeTranslation(head.position.x, head.position.y - offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(head.position.x, offset, 0))
                    
                head.updateMatrixWorld(true);

                stats.update();
                renderer.render(scene, camera);
            })

        let left_arm_angle = -Math.PI/16;
        let left_arm_tilt_duration = 600;

        let leftArmTween = new TWEEN.Tween({theta:0})
        .to({ theta: left_arm_angle}, left_arm_tilt_duration)
        .onUpdate(function() {
            let arm_pos_x = left_lower_arm.position.x;
            let arm_pos_y = left_lower_arm.position.y;
            let arm_offset = left_lower_arm.geometry.parameters.height/3.0;

            let hand_pos_x = left_hand.position.x;
            let hand_pos_y = left_hand.position.y;
            let hand_offset = left_hand.geometry.parameters.height/2.0;

            left_lower_arm.matrix.makeRotationZ(this._object.theta)
                .premultiply(new THREE.Matrix4().makeTranslation(arm_pos_x, arm_pos_y + arm_offset, 0))
                .multiply(new THREE.Matrix4().makeTranslation(0, -arm_offset, 0))
                
            left_hand.matrix.makeRotationZ(this._object.theta)
                .premultiply(new THREE.Matrix4().makeTranslation(hand_pos_x, hand_pos_y + hand_offset, 0))
                .multiply(new THREE.Matrix4().makeTranslation(0, -hand_offset, 0))

            left_hand.updateMatrixWorld(true);
            left_lower_arm.updateMatrixWorld(true);
            
            stats.update();
            renderer.render(scene, camera);
        })

        lowerArmTween.chain(handTweenOne);
        handTweenOne.chain(handTweenTwo);
        handTweenTwo.chain(handTweenThree);
        handTweenThree.chain(handTweenOne);
        
        //  upperArmTween.chain( ... ); this allows other related Tween animations occur at the same time
        upperArmTween.start()
        lowerArmTween.start()
        headTween.start()
        leftArmTween.start()

        this.upperArmTween = upperArmTween;
        this.lowerArmTween = lowerArmTween;
        this.handTweenOne = handTweenOne;
        this.handTweenTwo = handTweenTwo;
        this.handTweenThree = handTweenThree;
        this.leftArmTween = leftArmTween;
    },
    animate: function(time) {
        window.requestAnimationFrame(this.animate.bind(this));
        TWEEN.update(time);
    },
    run: function() {
        this.init();
        this.animate(0);
    },
    stop: function() {
        if (this.clipToInitialPositionTween !== undefined) this.clipToInitialPositionTween.stop();
        if (this.upperArmTween !== undefined) this.upperArmTween.stop();
        if (this.lowerArmTween !== undefined) this.lowerArmTween.stop();
        if (this.handTweenOne !== undefined) this.handTweenOne.stop();
        if (this.handTweenTwo !== undefined) this.handTweenTwo.stop();
        if (this.handTweenThree !== undefined) this.handTweenThree.stop();
        if (this.headTween !== undefined) this.headTween.stop();
        if (this.leftArmTween !== undefined) this.leftArmTween.stop();
    }
});