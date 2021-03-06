package samples;

import com.babylonhx.cameras.ArcRotateCamera;
import com.babylonhx.lights.DirectionalLight;
import com.babylonhx.lights.HemisphericLight;
import com.babylonhx.lights.shadows.ShadowGenerator;
import com.babylonhx.materials.ShaderMaterial;
import com.babylonhx.materials.ShadersStore;
import com.babylonhx.materials.StandardMaterial;
import com.babylonhx.materials.textures.CubeTexture;
import com.babylonhx.materials.textures.Texture;
import com.babylonhx.math.Color3;
import com.babylonhx.math.Vector3;
import com.babylonhx.mesh.Mesh;
import com.babylonhx.physics.PhysicsBodyCreationOptions;
import com.babylonhx.physics.plugins.OimoPlugin;
import com.babylonhx.Scene;
import com.babylonhx.physics.PhysicsEngine;

/**
 * ...
 * @author Krtolica Vujadin
 */
class Physics {

	public function new(scene:Scene) {
		scene.enablePhysics(new Vector3(0, -2, 0), new OimoPlugin());
						
		var camera = new ArcRotateCamera("Camera", 0.86, 1.37, 450, Vector3.Zero(), scene);
		camera.attachControl(this);
		camera.maxZ = 50000;
		
		var light = new HemisphericLight("hemi", new Vector3(0, 1, 0), scene);
				
		var mat = new StandardMaterial("ground", scene);
		var texDiff = new Texture("assets/img/wood.jpg", scene);
		texDiff.uScale = texDiff.vScale = 5;
		mat.diffuseTexture = texDiff;
		mat.specularColor = Color3.Black();
		
		var g = Mesh.CreateBox("ground", 400, scene);
		g.position.y = -30;
		g.scaling.y = 0.01;
		g.material = mat;
		var physOpt = new PhysicsBodyCreationOptions();
		physOpt.mass = 0;
		g.setPhysicsState(PhysicsEngine.BoxImpostor, physOpt);
		
		var b1 = Mesh.CreateBox("b1", 50, scene);
		b1.position.x = -10;
		b1.material = mat;
		b1.setPhysicsState(PhysicsEngine.BoxImpostor, physOpt);
		
		var b11 = Mesh.CreateBox("b1", 40, scene);
		b11.position.x = -100;
		b11.scaling.y = 3;
		b11.position.y = 30;
		b11.material = mat;
		b11.setPhysicsState(PhysicsEngine.BoxImpostor, physOpt);
		
		var b111 = Mesh.CreateBox("b1", 200, scene);
		b111.position.z = -180;
		b111.scaling.y = 0.03;
		b111.scaling.z = 0.5;
		b111.position.y = 80;
		b111.rotation.x = Math.PI / 5;
		b111.material = mat;
		b111.setPhysicsState(PhysicsEngine.BoxImpostor, physOpt);
		
		var b2 = Mesh.CreateBox("b2", 400, scene);
		b2.position.z = -200;
		b2.scaling.z = 0.01;
		b2.scaling.y = 0.15;
		b2.material = mat;
		b2.setPhysicsState(PhysicsEngine.BoxImpostor, physOpt);
		
		var b3 = Mesh.CreateBox("b2", 400, scene);
		b3.position.z = 200;
		b3.scaling.z = 0.01;
		b3.scaling.y = 0.15;
		b3.material = mat;
		b3.setPhysicsState(PhysicsEngine.BoxImpostor, physOpt);
		
		var b4 = Mesh.CreateBox("b2", 400, scene);
		b4.position.x = 200;
		b4.scaling.x = 0.01;
		b4.scaling.y = 0.15;
		b4.material = mat;
		b4.setPhysicsState(PhysicsEngine.BoxImpostor, physOpt);
		
		var b5 = Mesh.CreateBox("b2", 400, scene);
		b5.position.x = -200;
		b5.scaling.x = 0.01;
		b5.scaling.y = 0.15;
		b5.material = mat;
		b5.setPhysicsState(PhysicsEngine.BoxImpostor, physOpt);
		
		// Get a random number between two limits
		var randomNumber = function (min:Float, max:Float) {
			if (min == max) {
				return (min);
			}
			var random = Math.random();
			return Std.int((random * (max - min)) + min);
		};
		
		// Initial height
		var y = 50;
		
		// all our objects
		var objects:Array<Mesh> = [];
		
		// max number of objects
		var max = 100;
		
		// Creates a random position above the ground
		var getPosition = function(y:Float):Vector3 {
			return new Vector3(randomNumber(-200, 200), y, randomNumber(-200, 200));
		};
		
		
		var materialAmiga = new StandardMaterial("ball", scene);
		materialAmiga.diffuseTexture = new Texture("assets/img/rust.jpg", scene);
		materialAmiga.emissiveColor = new Color3(0.5, 0.5, 0.5);
		materialAmiga.diffuseTexture.uScale = 5;
		materialAmiga.diffuseTexture.vScale = 5;
		
		var materialCrate = new StandardMaterial("crate", scene);
		materialCrate.diffuseTexture = new Texture("assets/img/crate.png", scene);
		
		// Create objects
		for (index in 0...max) {
			
			// SPHERES
			var s = Mesh.CreateSphere("s", 30, randomNumber(20, 50), scene);
			s.position = getPosition(y + 250);
			s.material = materialAmiga;
			physOpt = new PhysicsBodyCreationOptions();
			physOpt.mass = 1;
			physOpt.friction = 0.5;
			physOpt.restitution = 0.5;
			s.setPhysicsState(PhysicsEngine.SphereImpostor, physOpt);
			
			// BOXES
			var d = Mesh.CreateBox("b", randomNumber(10, 30), scene);
			d.position = getPosition(y);
			d.material = materialCrate;
			
			d.rotation.x = randomNumber( -Math.PI / 2, Math.PI / 2);
			d.rotation.y = randomNumber( -Math.PI / 2, Math.PI / 2);
			d.rotation.z = randomNumber( -Math.PI / 2, Math.PI / 2);
			d.setPhysicsState(PhysicsEngine.BoxImpostor, physOpt);
			
			// SAVE OBJECT
			objects.push(s);
			objects.push(d);
			
			// INCREMENT HEIGHT
			y += 10;
		}
		
		trace(objects.length);
		
		/*scene.registerBeforeRender(function() {
			for(obj in objects) {
				// If object falls
				if (obj.position.y < -200) {
					obj.position = getPosition(20);
					obj.updatePhysicsBodyPosition();
				}
			}
		});*/
		
		scene.getEngine().runRenderLoop(function () {
			scene.render();
		});
	}
	
}
