import React from "react";
import { firebaseProperties } from "../fb";
import classes from "./Logueo.module.css";

import * as Constants from "../constants";

const Logueo = (props) => {
  //It is used to know if the user is registering or not
  const [isRegistering, setisRegistering] = React.useState(false);
  const [emailText, setEmailText] = React.useState("");
  const [passwordText, setPasswordText] = React.useState("");

  // handles user creation
  const createUser = (email, password) => {
    if (email === "" && password === "") {
      return;
    }
    firebaseProperties
      .auth()
      .createUserWithEmailAndPassword(email, password)
      .then((usuarioFirebase) => {
        console.log("created user:", usuarioFirebase);
        props.setUsuario(usuarioFirebase);
      })
      .catch((error) => {
        console.log("Create user Failed!", error);
        window.alert("Create user Failed!", error);
      });
  };

  // handles user login
  const logIn = (email, password) => {
    if (email === "" && password === "") {
      return;
    }
    firebaseProperties
      .auth()
      .signInWithEmailAndPassword(email, password)
      .then((usuarioFirebase) => {
        console.log("session started with:", usuarioFirebase.user);
        props.setUsuario(usuarioFirebase);
      })
      .catch((error) => {
        console.log("Login Failed!", error);
        window.alert("Login Failed!", error);
      });
  };

  const erase = () => {
    setEmailText("");
    setPasswordText("");
  };

  // It is executed with the submit of the form,
  // depending on the state of isRegistering, it executes create user or start session
  const submitHandler = (e) => {
    e.preventDefault(); /// Evita actualizar la pagina

    const email = e.target.emailField.value;
    const password = e.target.passwordField.value;

    console.log(emailText);
    if (isRegistering) {
      createUser(email, password);
    }

    if (!isRegistering) {
      logIn(email, password);
    }
  };

  const handleChangeEmail = (e) => {
    setEmailText(e.target.value);
  };

  const handleChangePassword = (e) => {
    setPasswordText(e.target.value);
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
              value={emailText}
              onChange={handleChangeEmail}
              required={true}
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
              required={true}
              value={passwordText}
              onChange={handleChangePassword}
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
          onClick={() => {
            setisRegistering(!isRegistering);
            erase();
          }}
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
