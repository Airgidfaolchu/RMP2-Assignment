package {

	 
	import com.gamua.flox.Flox;
	import com.gamua.flox.Player;
	import com.gamua.flox.utils.DateUtil;
    import com.gamua.flox.utils.formatString;

    import nape.callbacks.CbEvent;
    import nape.callbacks.CbType;
    import nape.callbacks.InteractionCallback;
    import nape.callbacks.InteractionListener;
    import nape.callbacks.InteractionType;
    import nape.callbacks.PreCallback;
    import nape.callbacks.PreFlag;
    import nape.callbacks.PreListener;
    import nape.dynamics.CollisionArbiter;
    import nape.geom.Vec2;
    import nape.phys.Body;
    import nape.phys.BodyType;
    import nape.phys.Material;
    import nape.shape.Circle;
    import nape.shape.Polygon;
	import nape.shape.Shape;
	
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import flash.events.MouseEvent;
    import flash.events.Event;
	
	import starling.utils.deg2rad;

    // Template class is used so that this sample may
    // be as concise as possible in showing Nape features without
    // any of the boilerplate that makes up the sample interfaces.
    import Template;

    public class ShapeSorter extends Template {
        public function ShapeSorter():void {
            super({
                gravity: Vec2.get(0, 600)
            });
        }
	
        private var oneWayType:CbType;
        private var teleporterType:CbType;
        private var kinematics:Array;
		private var bottomCollisionType:CbType;
		//Gamua Flox
		var currentPlayer:Player = Player.current;
		private var mPlayerId:String;
        private var mPlayerName:String;
        private var mValue:int;
        private var mDate:Date;
        private var mCountry:String;

        override protected function init():void {
            var w:uint = stage.stageWidth;
            var h:uint = stage.stageHeight;
			
			Flox.init("deySFlkexg2wV5Qq", "lcE1GYNuUMmYKQA3", "0.9");
			//Submit log entries
			Flox.logWarning("Something fishy is going on!");
			Flox.logEvent("Game initiated");

            // Set up one-way platform logic.
            //
            // We pass 'true' for the pure argument of PreListener constructor
            // so that (though not technically possible in this sample case due
            // to conveyor belts) objects may go to sleep whilst resting on the
            // platform. This is valid as the handler logic depends purely on
            // the input Arbiter data.
            //
            oneWayType = new CbType();
            space.listeners.add(new PreListener(
                InteractionType.COLLISION,
                oneWayType,
                CbType.ANY_BODY,
                oneWayHandler,
                /*precedence*/ 0,
                /*pure*/ true
            ));

            conveyor(192, 200); //y, speed of belt
            conveyor(384, 100);
            conveyor(576, 100);
            conveyor(758, 200); //bottom-left
			
			conveyor2(192, 200); //y, speed of belt
            conveyor2(384, 100);
            conveyor2(576, 100);
            conveyor2(0, 200); //top-right

            // Set up teleporter logic.
            teleporterType = new CbType();
            space.listeners.add(new InteractionListener(
                CbEvent.BEGIN,
                InteractionType.SENSOR,
                CbType.ANY_BODY,
                teleporterType,
                teleporterHandler
            ));
			
			//Set up bottomWall logic
            bottomCollisionType = new CbType();
            space.listeners.add(new InteractionListener(
                CbEvent.BEGIN,
                InteractionType.SENSOR,
                CbType.ANY_BODY,
                bottomCollisionType,
                bottomCollisionHandler
            ));

            // Create border at top and one at bottom to catch teleported
            // objects before platforms lift them up.
            var border:Body = new Body(BodyType.STATIC);
            border.shapes.add(new Polygon(Polygon.rect(-20, 0, w+40, -1)));
            border.shapes.add(new Polygon(Polygon.rect(-20, h, w+40, -1)));

            // Create teleporters on left and right
            var leftWall:Polygon = new Polygon(Polygon.rect(-20, 0, -1, 768));
            leftWall.sensorEnabled = true;
            leftWall.body = border;

            var rightWall:Polygon = new Polygon(Polygon.rect(w+20, 0, 1, 768));
            rightWall.sensorEnabled = true;
            rightWall.cbTypes.add(teleporterType);
            rightWall.body = border;
			
			var topWall:Polygon = new Polygon(Polygon.rect(240, h-h, 524, 1));
            topWall.sensorEnabled = true;
            topWall.cbTypes.add(teleporterType);
            topWall.body = border;
			
			var bottomWall:Polygon = new Polygon(Polygon.rect(300, h-1, 724, 1));
            bottomWall.sensorEnabled = true;
            bottomWall.cbTypes.add(bottomCollisionType);
            bottomWall.body = border;

            border.space = space;
			
			/////EXIT SENSORS/////
			// Only squares can go trough
			var wall1Body:Body = new Body(BodyType.STATIC);
            var wall1Shape:Shape = new Polygon(Polygon.rect(w-25, 10, 1, 180));
			wall1Shape.filter.collisionMask = 1;
            wall1Shape.body = wall1Body;
            wall1Body.space = space;
			
			var wall5Body:Body = new Body(BodyType.STATIC);
            var wall5Shape:Shape = new Polygon(Polygon.rect(w-15, 10, 1, 180));
			wall5Shape.filter.collisionMask = 4;
            wall5Shape.body = wall5Body;
            wall5Body.space = space;
			
			// Only circles go through
			var wall2Body:Body = new Body(BodyType.STATIC);
            var wall2Shape:Shape = new Polygon(Polygon.rect(w-25, 202, 1, 180));
			wall2Shape.filter.collisionMask = 2;
            wall2Shape.body = wall2Body;
            wall2Body.space = space;
			
			var wall6Body:Body = new Body(BodyType.STATIC);
            var wall6Shape:Shape = new Polygon(Polygon.rect(w-15, 202, 1, 180));
			wall6Shape.filter.collisionMask = 4;
            wall6Shape.body = wall6Body;
            wall6Body.space = space;
			
			// Only hexagons goes through
			var wall3Body:Body = new Body(BodyType.STATIC);
            var wall3Shape:Shape = new Polygon(Polygon.rect(w-25, 394, 1, 180));
			wall3Shape.filter.collisionMask = 3;
            wall3Shape.body = wall3Body;
            wall3Body.space = space;
			
			var wall7Body:Body = new Body(BodyType.STATIC);
            var wall7Shape:Shape = new Polygon(Polygon.rect(w-15, 394, 1, 180));
			wall7Shape.filter.collisionMask = 2;
            wall7Shape.body = wall7Body;
            wall7Body.space = space;
			
			// Nothing goes through
			var wall4Body:Body = new Body(BodyType.STATIC);
            var wall4Shape:Shape = new Polygon(Polygon.rect(w-225, 587, 1, 180));
			wall4Shape.filter.collisionMask = 4;
            wall4Shape.body = wall4Body;
            wall4Body.space = space;
			
			var wall8Body:Body = new Body(BodyType.STATIC);
            var wall8Shape:Shape = new Polygon(Polygon.rect(w-215, 587, 1, 180));
			wall8Shape.filter.collisionMask = 3;
            wall8Shape.body = wall8Body;
            wall8Body.space = space;
			
			/////EXIT SENSORS END/////
			
            // Create kinematic platforms to lift objects up.
            var iw:Number = (w+40)/20;
            kinematics = [];
            kinematic(585, iw, 60, 10);
            kinematic(585 + iw, iw, 120, 10);
            kinematic(585 + iw*2, iw, 240, 10);
            kinematic(585 + iw*3, iw, 180, 10);
			TimerEventExample();
			
			function TimerEventExample() {
            var myTimer:Timer = new Timer(10000, 5);
            myTimer.addEventListener(TimerEvent.TIMER, timerHandler);
            myTimer.start();
			Score(mPlayerId, mPlayerName, mValue, mDate, mCountry);
        }
		
        function timerHandler(event:TimerEvent):void {
            trace("Set of shapes added");
        
            // Create a load of bodies to play with.
            for (var i:int = 0; i < 3; i++) {
                var body:Body = new Body();
				
                // Add random one of either a Circle, Box or triangle.
                if (Math.random() < 0.33) { //create circle
                   //body.shapes.add(new Circle(20));
				   
					body.force.set(space.gravity.mul(2*body.gravMass, true));
					var circleShape:Shape = new Circle(40);
					circleShape.filter.collisionGroup = 1;					
					body.shapes.add(circleShape);
					
                }
                else if (Math.random() < 0.5) { //create square
	
					var squareShape:Shape = new Polygon(Polygon.box(40, 40));
					squareShape.filter.collisionGroup = 2;
					body.shapes.add(squareShape);
    
                }
                else { //create triangles
             
					var triangleShape:Shape = new Polygon(Polygon.regular(30, 30, 3));
					triangleShape.filter.collisionGroup = 4;
					body.shapes.add(triangleShape);
		
                }

				// Set to random position on stage and add to Space.
				body.position.setxy(-20, Math.random() * h);
				body.space = space;
            }
        }
		}

        override protected function postUpdate(deltaTime:Number):void {
            // Teleport kinematic to bottom of screen once it reaches top belt.
            for (var i:int = 0; i < kinematics.length; i++) {
                var k:Body = kinematics[i];
                if (k.position.y < k.userData.targetHeight) {
                    k.position.y = 768;
                }
            }
        }
		//override protected function mouseDown(ev:MouseEvent):void {
			
			//};
			
		//Gamua Functions
		/** Create a new score instance with the given values. */
        private function Score(playerId:String, playerName:String, 
                              value:int, date:Date, country:String)
        {
			value = 1;
            mPlayerId = playerId;
            mPlayerName = playerName;
            mCountry = country;
            mValue = value;
            mDate = new Date();
        }
        
        /** The ID of the player who posted the score. Note that this could be a guest player
         *  unknown to the server. */
        function get playerId():String { return mPlayerId; }

        /** The name of the player who posted the score. */
        function get playerName():String { return mPlayerName; }

        /** The actual value/score. */
        function get value():int { return mValue; }
        
        /** The date at which the score was posted. */
        function get date():Date { return mDate; }
        
        /** The country from which the score originated, in a two-letter country code. */
        function get country():String { return mCountry; }
                
    
		//Gamua functions End

        private function kinematic(x:Number, width:Number, speed:Number, target:Number):void {
            var platform:Body = new Body(BodyType.KINEMATIC);
            platform.position.setxy(x, 768);
            platform.shapes.add(new Polygon(Polygon.rect(0, 0, width, 10)));
            platform.velocity.y = -speed;
            platform.space = space;
            platform.userData.targetHeight = target;
            kinematics.push(platform);
        }

        private function conveyor(height:Number, speed:Number):void {
            var belt:Body = new Body(BodyType.STATIC);

            belt.shapes.add(new Polygon(Polygon.rect(-200, height, 440, 10)));
            belt.surfaceVel.x = speed;
            belt.cbTypes.add(oneWayType);
            belt.setShapeMaterials(Material.rubber());
            belt.space = space;
        }
		
		 private function conveyor2(height:Number, speed:Number):void {
            var belt:Body = new Body(BodyType.STATIC);

            belt.shapes.add(new Polygon(Polygon.rect(800, height, 440, 10)));
            belt.surfaceVel.x = speed;
            belt.cbTypes.add(oneWayType);
            belt.setShapeMaterials(Material.rubber());
            belt.space = space;
        }
		
		 private function bottomCollisionHandler(cb:InteractionCallback):void {
            // Always valid given that we used CbType.ANY_BODY for first option type.
		
            var object:Body = cb.int1.castBody;
            /*// However, since I did use CbType.ANY_BODY, I have to ensure we aren't
            // teleporting one of the kinematic platforms...*/
            if (object.type == BodyType.KINEMATIC) return;

            // Reset body velocities
			
            object.velocity.setxy(0, -200);									//bounce
            object.angularVel = 0;											//could make them spinning
			object.force.set(space.gravity.mul(-1*object.gravMass, true)); //dead shapes fly up
			object.type = BodyType.KINEMATIC;								
        }

        private function teleporterHandler(cb:InteractionCallback):void {
            // Always valid given that I used CbType.ANY_BODY for first option type.
            var object:Body = cb.int1.castBody;
            if (object.type == BodyType.KINEMATIC) return;
			object.space = null;
        }

        private function oneWayHandler(cb:PreCallback):PreFlag {
     
            var colArb:CollisionArbiter = cb.arbiter.collisionArbiter;

            if ((colArb.normal.y > 0) != cb.swapped) {
                return PreFlag.ACCEPT;
            }
            else {
                return PreFlag.ACCEPT;
            }
        }
    }
}
