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

  //http dir
  val httpConf = http.baseUrl("http://127.0.0.1:30000")


  // scenario for creating data
  val createD = scenario("Crear datos")
    .exec(http("Create")
      .post("/babynames")
      .check(status.is(200)) /*Verifies status equals 200*/
    )

  // scenario for get information  
  val selectD = scenario("Obtener datos")
    .exec(http("Select")
      .get("/babynames")
      .check(status.is(200)) /*Verifies status equals 200*/
    )

  // scenario for updating data
  val updateD = scenario("Actualizar datos")
    .exec(http("Update")
      .put("/babynames")
      .check(status.is(200)) /*Verifies status equals 200*/
    )
  
  // scenario for deleting data
  val deleteD = scenario("Borrar datos")
    .exec(http("Delete")
      .delete("/babynames")
      .check(status.is(200)) /*Verifies status equals 200*/
    )

  // Users per second 
  setUp(

    //Create - Load test 5 users per second during 30 minutes
    createD.inject(constantUsersPerSec(5) during (1800 seconds)),

    // Select - Load test 10 users per second during 30 minutes
    selectD.inject(constantUsersPerSec(10) during (1800 seconds)),

    //Update - Load test 2 users per second during 30 minutes
    updateD.inject(constantUsersPerSec(2) during (1800 seconds)),

    //Delete - Load test 5 users per second during 30 minutes
    deleteD.inject(constantUsersPerSec(5) during (1800 seconds))

  ).protocols(httpConf)
}