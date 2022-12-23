$(function() {
    'use strict';

    var rotateY = 0,
        rotateX = 0,
        rotateZ = 0,
        translateZ = 0,
        speedZ = 0,
        accelAvg = 0,
        initialAlpha = undefined,
        initialPinchDistance = undefined,
        initialTranslateZ = 0,
        deviceorientationActive = false,
        $e = $('#cube');

    function updateCube() {
        $e.css('transform', 'perspective(1600px) translateZ('+ translateZ +'px) rotateY('+ rotateY +'deg) rotateX('+ rotateX +'deg) rotateZ('+ rotateZ +'deg)');
    }

    $('body').on('wheel', function(event) {
        if (event.altKey || deviceorientationActive) {
            rotateZ += event.originalEvent.deltaX;
            translateZ += event.originalEvent.deltaY * 2;
        } else {
            rotateY += event.originalEvent.deltaX;
            rotateX -= event.originalEvent.deltaY;
        }

        updateCube();

        event.preventDefault();
    });

    $(window).on('deviceorientation', function(event) {
        deviceorientationActive = true;

        if (window.orientation == 90) {
            rotateY = -event.originalEvent.beta;
            rotateX = -event.originalEvent.gamma;
        } else if (window.orientation == -90) {
            rotateY = event.originalEvent.beta;
            rotateX = event.originalEvent.gamma;
        } else {
            rotateY = -event.originalEvent.gamma;
            rotateX = event.originalEvent.beta;
        }

        if (event.originalEvent.alpha) {
            if (initialAlpha === undefined)
                initialAlpha = event.originalEvent.alpha;

            rotateZ = event.originalEvent.alpha - initialAlpha;
        }

        updateCube();
    });

    $(window).on('orientationchange', function(event) {
        initialAlpha = undefined;
    });

    $(window).on('devicemotion', function(event) {

        var accelZ = event.originalEvent.acceleration.z;

        accelAvg = (accelAvg * 19 + accelZ) / 20;

        speedZ += (accelZ - accelAvg) * 100;
        speedZ *= 0.6;


        if ((translateZ < 300 || speedZ < 0) && (translateZ > -2000 || speedZ > 0))
            translateZ += speedZ;
    });

    $(window).on('touchstart', function(event) {
        initialPinchDistance = undefined;
        initialTranslateZ = translateZ;
        event.preventDefault();
    });

    $(window).on('touchmove', function(event) {
        var t = event.originalEvent.targetTouches;
        if (t.length > 1 && t[0].clientX && t[0].clientY && t[1].clientX && t[1].clientY) {
            var deltaX = t[1].clientX - t[0].clientX,
                deltaY = t[1].clientY - t[0].clientY,
                distance = Math.sqrt(deltaX * deltaX + deltaY * deltaY);

            if (initialPinchDistance === undefined)
                initialPinchDistance = distance;

            translateZ = initialTranslateZ + 2 * (distance - initialPinchDistance);

            updateCube();
        }
    });


    $e.on('click', function(event) {
        this.requestPointerLock = this.requestPointerLock || this.mozRequestPointerLock || this.webkitRequestPointerLock;
        this.requestPointerLock();
    });

    $(document).on('pointerlockchange mozpointerlockchange webkitpointerlockchange', function(event) {
        var pointerLockElement = document.pointerLockElement || document.mozPointerLockElement || document.webkitPointerLockElement;

        if (pointerLockElement) {
            $(window).off('deviceorientation');
            deviceorientationActive = false;

            $(document).on('mousemove', function(event) {
                var oe = event.originalEvent,
                    movementX = oe.movementX || oe.mozMovementX || oe.webkitMovementX || 0,
                    movementY = oe.movementY || oe.mozMovementY || oe.webkitMovementY || 0;

                if (event.altKey || event.buttons == 1 || (event.buttons === undefined && event.which == 1)) {
                    rotateZ += movementX;
                    translateZ += movementY * 2;
                } else {
                    rotateY += movementX;
                    rotateX -= movementY;
                }

                updateCube();
                event.preventDefault();
            });
        } else {
            $(document).off('mousemove');
        }
    });

});
