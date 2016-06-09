/**
* The base orm entity test case will use the 'model' annotation as the instantiation path
* and then create it, prepare it for mocking and then place it in the variables scope as 'model'. It is your
* responsibility to update the model annotation instantiation path and init your model.
*/
component extends="coldbox.system.testing.BaseModelTest" model="lib/model.Registration"{
	
	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		// load ColdBox
		this.loadColdbox = true;

		// setup the model
		super.setup();		
		
		// init the model object
		model.init();
	}

	function afterAll(){
	}

	/*********************************** BDD SUITES ***********************************/
	
	function run(){

		describe( "lib/model.Registration Suite", function(){
			

		});

	}

}
