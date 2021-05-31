

function YMCAAnimation() {}

Object.assign(YMCAAnimation.prototype, {

    init: function() {
        let right_upper_arm = robot.getObjectByName("right_upper_arm");
        let left_upper_arm = robot.getObjectByName("left_upper_arm");
        let right_lower_arm = right_upper_arm.getObjectByName("lower_arm");
        let left_lower_arm = left_upper_arm.getObjectByName("lower_arm");
        let right_hand = right_lower_arm.getObjectByName("hand");
        let left_hand = left_lower_arm.getObjectByName("hand");

        let y_arm_angle = 5*Math.PI/6;
        let m_arm_angle = Math.PI/2.7;
        let m_hand_angle = m_arm_angle;
        let m_upper_arm_angle = y_arm_angle + m_arm_angle/3;
        let c_right_upper_arm_angle = Math.PI/3.5;
        let c_left_upper_arm_angle = Math.PI;
        let a_upper_arm_angle = m_upper_arm_angle;
        let a_lower_arm_angle = m_arm_angle - Math.PI/16;

        let duration = 700;
        let animation_delay = 300;

        let yArmTween = new TWEEN.Tween( {theta:0} )
            .to( {theta:y_arm_angle }, duration)
            .onUpdate(function(){
                let right_pos_x = right_upper_arm.position.x;
                let right_pos_y = right_upper_arm.position.y;
                let right_offset = right_upper_arm.geometry.parameters.height/3.0;

                let left_pos_x = left_upper_arm.position.x;
                let left_pos_y = left_upper_arm.position.y;
                let left_offset = left_upper_arm.geometry.parameters.height/3.0;

                right_upper_arm.matrix.makeRotationZ(this._object.theta)
                    .premultiply(new THREE.Matrix4().makeTranslation(right_pos_x, right_pos_y + right_offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -right_offset, 0));

                left_upper_arm.matrix.makeRotationZ(-this._object.theta)
                    .premultiply(new THREE.Matrix4().makeTranslation(left_pos_x, left_pos_y + left_offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -left_offset, 0));

                right_upper_arm.updateMatrixWorld(true);
                left_upper_arm.updateMatrixWorld(true);

                stats.update();
                renderer.render(scene, camera);
            })

        let mUpperArmTween = new TWEEN.Tween({ theta: y_arm_angle })
            .to( {theta: m_upper_arm_angle}, duration)
            .onUpdate(function() {
                let right_pos_x = right_upper_arm.position.x;
                let right_pos_y = right_upper_arm.position.y;
                let right_offset = right_upper_arm.geometry.parameters.height/3.0 ;

                let left_pos_x = left_upper_arm.position.x;
                let left_pos_y = left_upper_arm.position.y;
                let left_offset = left_upper_arm.geometry.parameters.height/3.0;

                right_upper_arm.matrix.makeRotationZ(this._object.theta)
                    .premultiply(new THREE.Matrix4().makeTranslation(right_pos_x, right_pos_y + right_offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -right_offset, 0));

                left_upper_arm.matrix.makeRotationZ(-this._object.theta)
                    .premultiply(new THREE.Matrix4().makeTranslation(left_pos_x, left_pos_y + left_offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -left_offset, 0));

                right_upper_arm.updateMatrixWorld(true);
                left_upper_arm.updateMatrixWorld(true);

                stats.update();
                renderer.render(scene, camera); 
            })

        let mLowerArmTween = new TWEEN.Tween( {theta:0} )
            .to( {theta:m_arm_angle }, duration)
            .onUpdate(function(){
                let right_lower_pos_x = right_lower_arm.position.x;
                let right_lower_pos_y = right_lower_arm.position.y;
                let right_lower_offset = right_lower_arm.geometry.parameters.height/3.0;

                let left_lower_pos_x = left_lower_arm.position.x;
                let left_lower_pos_y = left_lower_arm.position.y;
                let left_lower_offset = left_lower_arm.geometry.parameters.height/3.0;

                right_lower_arm.matrix.makeRotationZ(this._object.theta)
                    .premultiply(new THREE.Matrix4().makeTranslation(right_lower_pos_x, right_lower_pos_y + right_lower_offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -right_lower_offset, 0));

                left_lower_arm.matrix.makeRotationZ(-this._object.theta)
                    .premultiply(new THREE.Matrix4().makeTranslation(left_lower_pos_x, left_lower_pos_y + left_lower_offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -left_lower_offset, 0));

                right_lower_arm.updateMatrixWorld(true);
                left_lower_arm.updateMatrixWorld(true);

                stats.update();
                renderer.render(scene, camera);
            })

        let mHandTween = new TWEEN.Tween({ theta:0 })
            .to( {theta:m_hand_angle }, 1.5*duration)
            .onUpdate(function(){
                let right_hand_pos_x = right_hand.position.x;
                let right_hand_pos_y = right_hand.position.y;
                let right_hand_offset = right_hand.geometry.parameters.height/2.0;

                let left_hand_pos_x = left_hand.position.x;
                let left_hand_pos_y = left_hand.position.y;
                let left_hand_offset = left_hand.geometry.parameters.height/2.0;

                right_hand.matrix.makeRotationZ(this._object.theta)
                    .premultiply(new THREE.Matrix4().makeTranslation(right_hand_pos_x, right_hand_pos_y + right_hand_offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -right_hand_offset, 0));

                left_hand.matrix.makeRotationZ(-this._object.theta)
                    .premultiply(new THREE.Matrix4().makeTranslation(left_hand_pos_x, left_hand_pos_y + left_hand_offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -left_hand_offset, 0));

                right_hand.updateMatrixWorld(true);
                left_hand.updateMatrixWorld(true);

                stats.update();
                renderer.render(scene, camera);
            })

        let cUpperArmTween = new TWEEN.Tween({ theta1:m_upper_arm_angle, theta2:m_upper_arm_angle})
            .to({ theta1:c_left_upper_arm_angle, theta2:c_right_upper_arm_angle}, duration)
            .onUpdate(function() {
                let right_pos_x = right_upper_arm.position.x;
                let right_pos_y = right_upper_arm.position.y;
                let right_offset = right_upper_arm.geometry.parameters.height/3.0;

                let left_pos_x = left_upper_arm.position.x;
                let left_pos_y = left_upper_arm.position.y;
                let left_offset = left_upper_arm.geometry.parameters.height/3.0;

                right_upper_arm.matrix.makeRotationZ(this._object.theta2)
                    .premultiply(new THREE.Matrix4().makeTranslation(right_pos_x, right_pos_y + right_offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -right_offset, 0));

                left_upper_arm.matrix.makeRotationZ(-this._object.theta1)
                    .premultiply(new THREE.Matrix4().makeTranslation(left_pos_x, left_pos_y + left_offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -left_offset, 0));

                right_upper_arm.updateMatrixWorld(true);
                left_upper_arm.updateMatrixWorld(true);

                stats.update();
                renderer.render(scene, camera); 
            })

        let cHandTween = new TWEEN.Tween({ theta:m_arm_angle })
            .to({ theta: 0 }, duration)
            .onUpdate(function() {
                let right_hand_pos_x = right_hand.position.x;
                let right_hand_pos_y = right_hand.position.y;
                let right_hand_offset = right_hand.geometry.parameters.height/2.0;

                let left_hand_pos_x = left_hand.position.x;
                let left_hand_pos_y = left_hand.position.y;
                let left_hand_offset = left_hand.geometry.parameters.height/2.0;

                right_hand.matrix.makeRotationZ(this._object.theta)
                    .premultiply(new THREE.Matrix4().makeTranslation(right_hand_pos_x, right_hand_pos_y + right_hand_offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -right_hand_offset, 0));

                left_hand.matrix.makeRotationZ(-this._object.theta)
                    .premultiply(new THREE.Matrix4().makeTranslation(left_hand_pos_x, left_hand_pos_y + left_hand_offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -left_hand_offset, 0));

                right_hand.updateMatrixWorld(true);
                left_hand.updateMatrixWorld(true);

                stats.update();
                renderer.render(scene, camera);
            })

        let aUpperArmTween = new TWEEN.Tween({ theta1:c_left_upper_arm_angle, theta2:c_right_upper_arm_angle })
            .to( { theta1:a_upper_arm_angle, theta2:a_upper_arm_angle}, duration)
            .onUpdate(function() {
                let right_pos_x = right_upper_arm.position.x;
                let right_pos_y = right_upper_arm.position.y;
                let right_offset = right_upper_arm.geometry.parameters.height/3.0;

                let left_pos_x = left_upper_arm.position.x;
                let left_pos_y = left_upper_arm.position.y;
                let left_offset = left_upper_arm.geometry.parameters.height/3.0;

                right_upper_arm.matrix.makeRotationZ(this._object.theta2)
                    .premultiply(new THREE.Matrix4().makeTranslation(right_pos_x, right_pos_y + right_offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -right_offset, 0));

                left_upper_arm.matrix.makeRotationZ(-this._object.theta1)
                    .premultiply(new THREE.Matrix4().makeTranslation(left_pos_x, left_pos_y + left_offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -left_offset, 0));

                right_upper_arm.updateMatrixWorld(true);
                left_upper_arm.updateMatrixWorld(true);

                stats.update();
                renderer.render(scene, camera); 
            })

        let aLowerArmTween = new TWEEN.Tween({ theta:m_arm_angle})
            .to({ theta: a_lower_arm_angle}, duration)
            .onUpdate(function() {
                let right_lower_pos_x = right_lower_arm.position.x;
                let right_lower_pos_y = right_lower_arm.position.y;
                let right_lower_offset = right_lower_arm.geometry.parameters.height/3.0;

                let left_lower_pos_x = left_lower_arm.position.x;
                let left_lower_pos_y = left_lower_arm.position.y;
                let left_lower_offset = left_lower_arm.geometry.parameters.height/3.0;

                right_lower_arm.matrix.makeRotationZ(this._object.theta)
                    .premultiply(new THREE.Matrix4().makeTranslation(right_lower_pos_x, right_lower_pos_y + right_lower_offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -right_lower_offset, 0));

                left_lower_arm.matrix.makeRotationZ(-this._object.theta)
                    .premultiply(new THREE.Matrix4().makeTranslation(left_lower_pos_x, left_lower_pos_y + left_lower_offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -left_lower_offset, 0));

                right_lower_arm.updateMatrixWorld(true);
                left_lower_arm.updateMatrixWorld(true);

                stats.update();
                renderer.render(scene, camera);
            })

        let initialPositionTween = new TWEEN.Tween({ theta_upper_arm:a_upper_arm_angle, theta_lower_arm:a_lower_arm_angle })
            .to({ theta_upper_arm:0, theta_lower_arm:0 })
            .onUpdate(function() {
                let right_pos_x = right_upper_arm.position.x;
                let right_pos_y = right_upper_arm.position.y;
                let right_offset = right_upper_arm.geometry.parameters.height/3.0;

                let left_pos_x = left_upper_arm.position.x;
                let left_pos_y = left_upper_arm.position.y;
                let left_offset = left_upper_arm.geometry.parameters.height/3.0;

                let right_lower_pos_x = right_lower_arm.position.x;
                let right_lower_pos_y = right_lower_arm.position.y;
                let right_lower_offset = right_lower_arm.geometry.parameters.height/3.0;

                let left_lower_pos_x = left_lower_arm.position.x;
                let left_lower_pos_y = left_lower_arm.position.y;
                let left_lower_offset = left_lower_arm.geometry.parameters.height/3.0;

                right_upper_arm.matrix.makeRotationZ(this._object.theta_upper_arm)
                    .premultiply(new THREE.Matrix4().makeTranslation(right_pos_x, right_pos_y + right_offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -right_offset, 0));

                left_upper_arm.matrix.makeRotationZ(-this._object.theta_upper_arm)
                    .premultiply(new THREE.Matrix4().makeTranslation(left_pos_x, left_pos_y + left_offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -left_offset, 0));

                right_upper_arm.updateMatrixWorld(true);
                left_upper_arm.updateMatrixWorld(true);

                stats.update();
                renderer.render(scene, camera); 

                right_lower_arm.matrix.makeRotationZ(this._object.theta_lower_arm)
                    .premultiply(new THREE.Matrix4().makeTranslation(right_lower_pos_x, right_lower_pos_y + right_lower_offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -right_lower_offset, 0));

                left_lower_arm.matrix.makeRotationZ(-this._object.theta_lower_arm)
                    .premultiply(new THREE.Matrix4().makeTranslation(left_lower_pos_x, left_lower_pos_y + left_lower_offset, 0))
                    .multiply(new THREE.Matrix4().makeTranslation(0, -left_lower_offset, 0));

                right_lower_arm.updateMatrixWorld(true);
                left_lower_arm.updateMatrixWorld(true);

                stats.update();
                renderer.render(scene, camera);
            })

        // set animations' delay 
        yArmTween.delay(2*animation_delay);
        mUpperArmTween.delay(animation_delay);
        mLowerArmTween.delay(animation_delay);
        mHandTween.delay(animation_delay);
        cUpperArmTween.delay(animation_delay);
        cHandTween.delay(animation_delay);
        aUpperArmTween.delay(animation_delay);
        aLowerArmTween.delay(animation_delay);
        initialPositionTween.delay(animation_delay);

        yArmTween.chain(mUpperArmTween, mLowerArmTween, mHandTween);
        mHandTween.chain(cUpperArmTween, cHandTween);
        cHandTween.chain(aUpperArmTween, aLowerArmTween);
        aLowerArmTween.chain(initialPositionTween);
        initialPositionTween.chain(yArmTween);

        yArmTween.start();

        this.yArmTween = yArmTween;
        this.mUpperArmTween = mUpperArmTween;
        this.mLowerArmTween = mLowerArmTween;
        this.mHandTween = mHandTween;
        this.cUpperArmTween = cUpperArmTween;
        this.cHandTween = cHandTween;
        this.aUpperArmTween = aUpperArmTween;
        this.aLowerArmTween = aLowerArmTween;
        this.initialPositionTween = initialPositionTween;
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
        if (this.yArmTween !== undefined) this.yArmTween.stop();
        if (this.mUpperArmTween !== undefined) this.mUpperArmTween.stop();
        if (this.mLowerArmTween !== undefined) this.mLowerArmTween.stop();
        if (this.mHandTween !== undefined) this.mHandTween.stop();
        if (this.cUpperArmTween !== undefined) this.cUpperArmTween.stop();
        if (this.cHandTween !== undefined) this.cHandTween.stop();
        if (this.aUpperArmTween !== undefined) this.aUpperArmTween.stop();
        if (this.aLowerArmTween !== undefined) this.aLowerArmTween.stop();
        if (this.initialPositionTween !== undefined) this.initialPositionTween.stop();
    }
});