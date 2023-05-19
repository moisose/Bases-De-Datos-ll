import React from "react";
import { firebaseProperties } from "../fb";
import classes from "./Logueo.module.css";

import * as Constants from "../constants";

const Logueo = (props) => {
  //It is used to know if the user is registering or not
  const [isRegistering, setisRegistering] = React.useState(false);

  // handles user creation
  const crearUsuario = (correo, password) => {
    firebaseProperties
      .auth()
      .createUserWithEmailAndPassword(correo, password)
      .then((usuarioFirebase) => {
        console.log("created user:", usuarioFirebase);
        props.setUsuario(usuarioFirebase);
      });
  };

  // handles user login
  const iniciarSesion = (correo, password) => {
    firebaseProperties
      .auth()
      .signInWithEmailAndPassword(correo, password)
      .then((usuarioFirebase) => {
        console.log("session started with:", usuarioFirebase.user);
        props.setUsuario(usuarioFirebase);
      });
  };

  // It is executed with the submit of the form,
  // depending on the state of isRegistering, it executes create user or start session
  const submitHandler = (e) => {
    e.preventDefault(); /// Evita actualizar la pagina
    const correo = e.target.emailField.value;
    const password = e.target.passwordField.value;

    if (isRegistering) {
      crearUsuario(correo, password);
    }

    if (!isRegistering) {
      iniciarSesion(correo, password);
    }
  };

  return (
    <div>
      {/* <h1> {isRegistering ? "Regístrate" : "Inicia sesión"}</h1> */}
      <form onSubmit={submitHandler} className={classes.loginForm}>
        {isRegistering ? (
          <img src={Constants.userImg} alt="user icon" />
        ) : (
          <img src={Constants.loginImg} alt="login icon" />
        )}

        <h1 className={classes.title}>
          {" "}
          {isRegistering ? "Create account" : "Sign in"}
        </h1>
        {isRegistering ? (
          <p>Personal information</p>
        ) : (
          <p>Sign in to your account</p>
        )}

        <div className={classes.box}>
          <label className={classes.subTitle} htmlFor="email">
            Email
          </label>
          <div className={classes.inputContainer}>
            <input
              className={classes.input}
              type="email"
              required="true"
              placeholder="Enter your email"
              id="emailField"
            />
            <div className={classes.highlight}></div>
          </div>

          <label className={classes.subTitle} htmlFor="passwordField">
            Password
          </label>
          <div className={classes.inputContainer}>
            <input
              className={classes.input}
              type="password"
              required="true"
              placeholder="Enter your password"
              id="passwordField"
            />
            <div className={classes.highlight}></div>
          </div>

          <button className={classes.button} type="submit">
            {" "}
            {isRegistering ? <span>Create</span> : <span>Sign in</span>}
          </button>
        </div>
        <button
          className={classes.link}
          onClick={() => setisRegistering(!isRegistering)}
        >
          {isRegistering
            ? "Already have an account? Sign in"
            : "Don't have an account? Join now"}
        </button>
      </form>
    </div>
  );
};

export default Logueo;
