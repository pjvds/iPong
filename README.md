# iPong
A simple pong implementation that runs on IOS.

# Tech stuff
The following stuff is used to create this Pong implementation for IOS:

* XCode 4.x
* Objective C
* Cocos2D
* Box2D
* Freetime in an hotel in Rotterdam

# What you need to know about Box2D
Box2D works with several fundamental objects. We briefly define these objects here and more details are given later in this document.

## world
A physics world is a collection of bodies, fixtures, and constraints that interact together. Box2D supports the creation of multiple worlds, but this is usually not necessary or desirable.

## shape
A 2D geometrical object, such as a circle or polygon.

## rigid body
A chunk of matter that is so strong that the distance between any two bits of matter on the chunk is completely constant. They are hard like a diamond. In the following discussion we use body interchangeably with rigid body.

## fixture
A fixture binds a shape to a body and adds material properties such as density, friction, and restitution.

## constraint
A constraint is a physical connection that removes degrees of freedom from bodies. In 2D a body has 3 degrees of freedom (two translation coordinates and one rotation coordinate). If we take a body and pin it to the wall (like a pendulum) we have constrained the body to the wall. At this point the body can only rotate about the pin, so the constraint has removed 2 degrees of freedom.

## contact constraint
A special constraint designed to prevent penetration of rigid bodies and to simulate friction and restitution. You do not create contact constraints; they are created automatically by Box2D.

## joint
This is a constraint used to hold two or more bodies together. Box2D supports several joint types: revolute, prismatic, distance, and more. Some joints may have limits and motors.

## joint limit
A joint limit restricts the range of motion of a joint. For example, the human elbow only allows a certain range of angles.

## joint motor
A joint motor drives the motion of the connected bodies according to the joint's degrees of freedom. For example, you can use a motor to drive the rotation of an elbow.

# Code Fest
I created this for the Devnology [Code Fest][1]. using XCode, ObjC and the Cocos2D Box2d framework.

[1]: http://devnology.nl/en/meetings/details/33-the-legacy-code-fest