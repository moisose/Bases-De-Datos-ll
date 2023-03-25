/*
loadTest.scala

gatling-charts-highcharts-bundle-3.9.2/users-files/simulation

Import of libs
*/
import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._

/*
Class testDataset
*/
class testDataset extends Simulation {

  /*define http dir*/
  val httpConf = http.baseUrl("http://127.0.0.1:30000")


  //define scenario for creating data
  val createD = scenario("Crear datos")
    .exec(http("Create")
      .post("/babynames")
      .check(status.is(200)) /*Verifies status equals 200*/
    )

  //define scenario for get information  
  val selectD = scenario("Obtener datos")
    .exec(http("Select")
      .get("/babynames")
      .check(status.is(200)) /*Verifies status equals 200*/
    )

  //define scenario for updating data
  val updateD = scenario("Actualizar datos")
    .exec(http("Update")
      .put("/babynames")
      .check(status.is(200)) /*Verifies status equals 200*/
    )
  
  //define scenario for deleting data
  val deleteD = scenario("Borrar datos")
    .exec(http("Delete")
      .delete("/babynames")
      .check(status.is(200)) /*Verifies status equals 200*/
    )

  // Users per second 
  setUp(
    // Load test 5 users per Second during 30 seconds

    //Create 
    createD.inject(constantUsersPerSec(3) during (1800 seconds)),

    // Select 
    selectD.inject(constantUsersPerSec(6) during (1800 seconds)),

    //Update
    updateD.inject(constantUsersPerSec(1) during (1800 seconds)),

    //Delete
    deleteD.inject(constantUsersPerSec(3) during (1800 seconds))

  ).protocols(httpConf)
}