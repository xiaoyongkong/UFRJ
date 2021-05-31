function SquatAnimation() {}

Object.assign(SquatAnimation.prototype, {

    init: function() {

        let torso = robot.getObjectByName("torso");

        let right_upper_leg = robot.getObjectByName("right_upper_leg");
        let left_upper_leg = robot.getObjectByName("left_upper_leg");
        let right_lower_leg = right_upper_leg.getObjectByName("lower_leg");
        let left_lower_leg = left_upper_leg.getObjectByName("lower_leg");
        let right_foot = right_lower_leg.getObjectByName("foot");
        let left_foot = left_lower_leg.getObjectByName("foot");

        let right_upper_arm = robot.getObjectByName("right_upper_arm");
        let left_upper_arm = robot.getObjectByName("left_upper_arm");
        let right_lower_arm = right_upper_arm.getObjectByName("lower_arm");
        let left_lower_arm = left_upper_arm.getObjectByName("lower_arm");
        let right_hand = right_lower_arm.getObjectByName("hand");
        let left_hand = left_lower_arm.getObjectByName("hand");

        let torso_offset = -2;
        let leg_angle = 5*Math.PI/9;
        let arm_angle = Math.PI/6;
        let lower_arm_angle = 4*Math.PI/6;

        let squatTween = new TWEEN.Tween( {theta_leg:0, torso_y:0, knee_x:0, knee_y:0, ankle_y:0, theta_arm:0, theta_lower_arm:0} )
            .to( {theta_leg:leg_angle, torso_y:torso_offset, knee_x:-1.2, knee_y:0.2, ankle_y:-1.5, theta_arm:arm_angle, theta_lower_arm:lower_arm_angle}, 700)
            .onUpdate(function() {                
                let right_pos_x = right_upper_leg.position.x;
                let right_pos_y = right_upper_leg.position.y;
                let right_offset = right_upper_leg.geometry.parameters.height/3.0;

                let left_pos_x = left_upper_leg.position.x;
                let left_pos_y = left_upper_leg.position.y;
                let left_offset = left_upper_leg.geometry.parameters.height/3.0;

                let right_lower_pos_x = right_lower_leg.position.x;
                let right_lower_pos_y = right_lower_leg.position.y;
                let right_lower_offset = right_lower_leg.geometry.parameters.height/3.0;

                let left_lower_pos_x = left_lower_leg.position.x;
                let left_lower_pos_y = left_lower_leg.position.y;
                let left_lower_offset = left_lower_leg.geometry.parameters.height/3.0;

                let right_foot_pos_x = right_foot.position.x;
                let right_foot_pos_y = right_foot.position.y;
                let left_foot_pos_x = left_foot.position.x;
                let left_foot_pos_y = left_foot.position.y;

                let right_arm_pos_x = right_upper_arm.position.x;
                let right_arm_pos_y = right_upper_arm.position.y;
                let right_arm_offset = right_upper_arm.geometry.parameters.height/3.0;

                let left_arm_pos_x = left_upper_arm.position.x;
                let left_arm_pos_y = left_upper_arm.position.y;
                let left_arm_offset = left_upper_arm.geometry.parameters.height/3.0;

                let right_arm_lower_pos_x = right_lower_arm.position.x;
                let right_arm_lower_pos_y = right_lower_arm.position.y;
                let right_arm_lower_offset = right_lower_arm.geometry.parameters.height/3.0;

                let left_arm_lower_pos_x = left_lower_arm.position.x;
                let left_arm_lower_pos_y = left_lower_arm.position.y;
                let left_arm_lower_offset = left_lower_arm.geometry.parameters.height/3.0;

                torso.matrix.makeTranslation(0, this._object.torso_y, 0)

                right_upper_leg.matrix.makeRotationZ(this._object.theta_leg)
                    .premultiply(new THREE.Matrix4().makeTranslation(right_pos_x, right_pos_y + right_offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -right_offset, 0));

                left_upper_leg.matrix.makeRotationZ(-this._object.theta_leg)
                    .premultiply(new THREE.Matrix4().makeTranslation(left_pos_x, left_pos_y + left_offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -left_offset, 0));

                right_lower_leg.matrix.makeRotationZ(-this._object.theta_leg)
                    .premultiply(new THREE.Matrix4().makeTranslation(right_lower_pos_x + this._object.knee_x, right_lower_pos_y + right_lower_offset + this._object.knee_y, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -right_lower_offset, 0));

                left_lower_leg.matrix.makeRotationZ(this._object.theta_leg)
                    .premultiply(new THREE.Matrix4().makeTranslation(left_lower_pos_x - this._object.knee_x, left_lower_pos_y + left_lower_offset + this._object.knee_y, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -left_lower_offset, 0));

                right_foot.matrix.makeRotationZ(-this._object.theta_leg/4)
                    .premultiply(new THREE.Matrix4().makeTranslation(right_foot_pos_x, right_foot_pos_y + this._object.ankle_y, 0))
            
                left_foot.matrix.makeRotationZ(this._object.theta_leg/4)
                    .premultiply(new THREE.Matrix4().makeTranslation(left_foot_pos_x, left_foot_pos_y + this._object.ankle_y, 0))
            
                right_upper_arm.matrix.makeRotationZ(this._object.theta_arm)
                    .premultiply(new THREE.Matrix4().makeTranslation(right_arm_pos_x, right_arm_pos_y + right_arm_offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -right_arm_offset, 0));

                left_upper_arm.matrix.makeRotationZ(-this._object.theta_arm)
                    .premultiply(new THREE.Matrix4().makeTranslation(left_arm_pos_x, left_arm_pos_y + left_arm_offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -left_arm_offset, 0));

                right_lower_arm.matrix.makeRotationZ(this._object.theta_lower_arm)
                    .premultiply(new THREE.Matrix4().makeTranslation(right_arm_lower_pos_x, right_arm_lower_pos_y + right_arm_lower_offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -right_arm_lower_offset, 0));

                left_lower_arm.matrix.makeRotationZ(-this._object.theta_lower_arm)
                    .premultiply(new THREE.Matrix4().makeTranslation(left_arm_lower_pos_x, left_arm_lower_pos_y + left_arm_lower_offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -left_arm_lower_offset, 0));


                torso.updateMatrixWorld(true);

                right_upper_leg.updateMatrixWorld(true);
                left_upper_leg.updateMatrixWorld(true);
                right_lower_leg.updateMatrixWorld(true);
                left_lower_leg.updateMatrixWorld(true);
                right_foot.updateMatrixWorld(true);
                left_foot.updateMatrixWorld(true);

                right_upper_arm.updateMatrixWorld(true);
                left_upper_arm.updateMatrixWorld(true);
                right_lower_arm.updateMatrixWorld(true);
                left_lower_arm.updateMatrixWorld(true);
                right_hand.updateMatrixWorld(true);
                left_hand.updateMatrixWorld(true);

                stats.update();
                renderer.render(scene, camera);
            })

        let getUpTween = new TWEEN.Tween( {theta_leg:leg_angle, torso_y:torso_offset, knee_x:-1.2, knee_y:0.2, ankle_y:-1.5, theta_arm:arm_angle, theta_lower_arm:lower_arm_angle} )
            .to( {theta_leg:0, torso_y:0, knee_x:0, knee_y:0, ankle_y:0, theta_arm:0, theta_lower_arm:0}, 700)
            .onUpdate(function() { 
                let right_pos_x = right_upper_leg.position.x;
                let right_pos_y = right_upper_leg.position.y;
                let right_offset = right_upper_leg.geometry.parameters.height/3.0;

                let left_pos_x = left_upper_leg.position.x;
                let left_pos_y = left_upper_leg.position.y;
                let left_offset = left_upper_leg.geometry.parameters.height/3.0;

                let right_lower_pos_x = right_lower_leg.position.x;
                let right_lower_pos_y = right_lower_leg.position.y;
                let right_lower_offset = right_lower_leg.geometry.parameters.height/3.0;

                let left_lower_pos_x = left_lower_leg.position.x;
                let left_lower_pos_y = left_lower_leg.position.y;
                let left_lower_offset = left_lower_leg.geometry.parameters.height/3.0;

                let right_foot_pos_x = right_foot.position.x;
                let right_foot_pos_y = right_foot.position.y;
                let left_foot_pos_x = left_foot.position.x;
                let left_foot_pos_y = left_foot.position.y;

                let right_arm_pos_x = right_upper_arm.position.x;
                let right_arm_pos_y = right_upper_arm.position.y;
                let right_arm_offset = right_upper_arm.geometry.parameters.height/3.0;

                let left_arm_pos_x = left_upper_arm.position.x;
                let left_arm_pos_y = left_upper_arm.position.y;
                let left_arm_offset = left_upper_arm.geometry.parameters.height/3.0;

                let right_arm_lower_pos_x = right_lower_arm.position.x;
                let right_arm_lower_pos_y = right_lower_arm.position.y;
                let right_arm_lower_offset = right_lower_arm.geometry.parameters.height/3.0;

                let left_arm_lower_pos_x = left_lower_arm.position.x;
                let left_arm_lower_pos_y = left_lower_arm.position.y;
                let left_arm_lower_offset = left_lower_arm.geometry.parameters.height/3.0;

                torso.matrix.makeTranslation(0, this._object.torso_y, 0)

                right_upper_leg.matrix.makeRotationZ(this._object.theta_leg)
                    .premultiply(new THREE.Matrix4().makeTranslation(right_pos_x, right_pos_y + right_offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -right_offset, 0));

                left_upper_leg.matrix.makeRotationZ(-this._object.theta_leg)
                    .premultiply(new THREE.Matrix4().makeTranslation(left_pos_x, left_pos_y + left_offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -left_offset, 0));

                right_lower_leg.matrix.makeRotationZ(-this._object.theta_leg)
                    .premultiply(new THREE.Matrix4().makeTranslation(right_lower_pos_x + this._object.knee_x, right_lower_pos_y + right_lower_offset + this._object.knee_y, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -right_lower_offset, 0));

                left_lower_leg.matrix.makeRotationZ(this._object.theta_leg)
                    .premultiply(new THREE.Matrix4().makeTranslation(left_lower_pos_x - this._object.knee_x, left_lower_pos_y + left_lower_offset + this._object.knee_y, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -left_lower_offset, 0));

                right_foot.matrix.makeRotationZ(-this._object.theta_leg/4)
                    .premultiply(new THREE.Matrix4().makeTranslation(right_foot_pos_x, right_foot_pos_y + this._object.ankle_y, 0))
            
                left_foot.matrix.makeRotationZ(this._object.theta_leg/4)
                    .premultiply(new THREE.Matrix4().makeTranslation(left_foot_pos_x, left_foot_pos_y + this._object.ankle_y, 0))
            
                right_upper_arm.matrix.makeRotationZ(this._object.theta_arm)
                    .premultiply(new THREE.Matrix4().makeTranslation(right_arm_pos_x, right_arm_pos_y + right_arm_offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -right_arm_offset, 0));

                left_upper_arm.matrix.makeRotationZ(-this._object.theta_arm)
                    .premultiply(new THREE.Matrix4().makeTranslation(left_arm_pos_x, left_arm_pos_y + left_arm_offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -left_arm_offset, 0));

                right_lower_arm.matrix.makeRotationZ(this._object.theta_lower_arm)
                    .premultiply(new THREE.Matrix4().makeTranslation(right_arm_lower_pos_x, right_arm_lower_pos_y + right_arm_lower_offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -right_arm_lower_offset, 0));

                left_lower_arm.matrix.makeRotationZ(-this._object.theta_lower_arm)
                    .premultiply(new THREE.Matrix4().makeTranslation(left_arm_lower_pos_x, left_arm_lower_pos_y + left_arm_lower_offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -left_arm_lower_offset, 0));


                torso.updateMatrixWorld(true);

                right_upper_leg.updateMatrixWorld(true);
                left_upper_leg.updateMatrixWorld(true);
                right_lower_leg.updateMatrixWorld(true);
                left_lower_leg.updateMatrixWorld(true);
                right_foot.updateMatrixWorld(true);
                left_foot.updateMatrixWorld(true);

                right_upper_arm.updateMatrixWorld(true);
                left_upper_arm.updateMatrixWorld(true);
                right_lower_arm.updateMatrixWorld(true);
                left_lower_arm.updateMatrixWorld(true);
                right_hand.updateMatrixWorld(true);
                left_hand.updateMatrixWorld(true);

                stats.update();
                renderer.render(scene, camera);
            })

        squatTween.chain(getUpTween);
        getUpTween.chain(squatTween);
        squatTween.delay(500);
        getUpTween.delay(500);

        squatTween.start();

        this.squatTween = squatTween;
        this.getUpTween = getUpTween;
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
        if (this.squatTween !== undefined) this.squatTween.stop();
        if (this.getUpTween !== undefined) this.getUpTween.stop();
    }
});