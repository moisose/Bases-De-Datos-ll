import React from "react";
import { Link } from "react-router-dom";
import { firebaseProperties } from "../fb";

import classes from "./Home.module.css";

// we are going to do 
// logo header
// nav content
// footer

const Home = () => {
  // const cerrarSesion = () => {
  //   firebaseProperties.auth().signOut();
  // };
  return (
    <div className={classes.container}>

      <div className={classes.logo}>
        Logo
        <Link to="/" className={classes.logout}>
        Log out
      </Link>
        </div>
      <div className={classes.header}>header</div>
      <div className={classes.nav}>nav</div>
      <div className={classes.content}>content</div>
      <div className={classes.footer}>footer</div>
      <h1>BUSCADOR MIEO.</h1>


    </div>

  );
};

export default Home;
