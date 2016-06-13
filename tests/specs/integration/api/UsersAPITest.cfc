/*******************************************************************************
*	Users API Tests
*******************************************************************************/
component extends="BaseAPITest" appMapping="/" accessors=true{
	property name="BaseURL" default='/api/v1/users';
	
	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
		// do your own stuff here
	}

	function afterAll(){
		// do your own stuff here
		super.afterAll();
		var UserService = Wirebox.getInstance("UserService");

		var testUsers = Wirebox.getInstance("User").findAllByFirstNameAndLastName("BDD","TestUser");
		for(var user in testUsers){
			user.delete();
		}
	}

	/*********************************** BDD SUITES ***********************************/
	
	function run(){

		describe(title="CRUD API Methods and Retrieval",asyncAll=false,body=function(){
			it("Tests the ability to create a user",function(){
				
				var regData = {
					"firstName":"BDD",
					"lastName":"TestUser",
					"company":"Ortus Solutions",
					"title":"Tester",
					"email":"test" & createUUID() & "@email.com",
					"password":"testing"
				}

				VARIABLES.regData = regData;

				var resp = apiCall(url=BaseURL,type="POST",data=regData);
				var respData = expectConsistentAPIResponse(resp,201);
				expect( respData ).toHaveKey( "user" );
				respData = respData.user;
				expect(respData).toHaveKey('href');
				//test that our password data has been removed
				expect(structKeyExists(respData,'password')).toBeFalse();
				//test for key matches - public data
				expect(respData).toHaveKey('FirstName');
				expect(respData.firstName).toBe(regData.firstName);
				expect(respData).toHaveKey('LastName');
				expect(respData.lastName).toBe(regData.lastName);
				VARIABLES.testUser = respData
				VARIABLES.testUserHref = respData.href;
				

				describe(title="Runs tests against created user",asyncAll=false, body=function(){

					it("Tests list methods",function(){
						expect(VARIABLES).toHaveKey('testUser');
						var resp = apiCall(url=BaseURL);
						var apiResponse = expectConsistentAPIResponse(resp,200);
						expect(apiResponse).toBeStruct();
						expect(apiResponse).toHaveKey('users');
						expect(apiResponse.users).toBeArray();
						expect(arrayLen(apiResponse.users)).toBeGT(0);
					});


					it("Tests the ability to retrieve the created user record",function(){
						expect(VARIABLES).toHavekey('testUser');
						var resp = apiCall( url=testUser.href );
						var respData = expectConsistentAPIResponse( resp, 200 );
						expect( respData ).toBeStruct();
						expect( respData ).toHaveKey("user");
						expect( respData.user ).toBeStruct();
						expect( respData.user ).toHaveKey("id");
						expect( respData.user.id ).toBe( VARIABLES.testUser.id );
					});

					it( "Tests the ability to update a user record", function(){
						expect( VARIABLES ).toHaveKey( "testUser" );
						var updateData = {
							"title":"Senior Developer"
						};
						var resp = apiCall( url=testUser.href,data=updateData,type="PUT" );
						var respData = expectConsistentAPIResponse(resp,200);
						expect( respData ).toHaveKey( "user" );
						expect( respData.user ).toBeStruct();
						respData = respData.user;
						expect( respData ).toHaveKey("id");
						expect( respData.id ).toBe( VARIABLES.testUser.id );
						expect( respData ).toHaveKey( "title" );
						expect( respData.title ).toBe( updateData.title );

					});

				});
			});
		});

	}

}
