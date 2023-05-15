import React from "react";
import { Link } from "react-router-dom";
import { firebaseProperties } from "../fb";

import classes from "./Home.module.css";

const Home = () => {
  // const cerrarSesion = () => {
  //   firebaseProperties.auth().signOut();
  // };
  return (
    <div>
      <h1>BUSCADOR MIEO.</h1>
      <Link to="/" className={classes.logout}>
        Log out
      </Link>
      {/* <button onClick={cerrarSesion}>Cerrar Sesión</button> */}
    </div>
  );
};

export default Home;
