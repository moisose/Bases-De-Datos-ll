import React from "react";
import { firebaseProperties } from "../fb";
import classes from "./Logueo.module.css";

const Logueo = (props) => {
  const [isRegistrando, setIsRegistrando] = React.useState(false);

  const crearUsuario = (correo, password) => {
    firebaseProperties
      .auth()
      .createUserWithEmailAndPassword(correo, password)
      .then((usuarioFirebase) => {
        console.log("usuario creado:", usuarioFirebase);
        props.setUsuario(usuarioFirebase);
      });
  };

  const iniciarSesion = (correo, password) => {
    firebaseProperties
      .auth()
      .signInWithEmailAndPassword(correo, password)
      .then((usuarioFirebase) => {
        console.log("sesión iniciada con:", usuarioFirebase.user);
        props.setUsuario(usuarioFirebase);
      });
  };

  const submitHandler = (e) => {
    e.preventDefault(); /// Evita actualizar la pagina
    const correo = e.target.emailField.value;
    const password = e.target.passwordField.value;

    if (isRegistrando) {
      crearUsuario(correo, password);
    }

    if (!isRegistrando) {
      iniciarSesion(correo, password);
    }
  };

  return (
    <div>
      {/* <h1> {isRegistrando ? "Regístrate" : "Inicia sesión"}</h1> */}
      <form onSubmit={submitHandler} className={classes.loginForm}>
        {isRegistrando ? (
          <img src="/user.png" alt="login icon" />
        ) : (
          <img src="/login.png" alt="login icon" />
        )}

        <h1 className={classes.title}>
          {" "}
          {isRegistrando ? "Create account" : "Sign in"}
        </h1>
        <p>Sign in to your account</p>
        <div className={classes.box}>
          <label className={classes.subTitle} htmlFor="email">
            Email
          </label>
          <input type="email" placeholder="Enter your email" id="emailField" />
          <label className={classes.subTitle} htmlFor="passwordField">
            Password
          </label>
          <input
            type="password"
            placeholder="Enter your password"
            id="passwordField"
          />
          <button className={classes.button} type="submit">
            {" "}
            {isRegistrando ? "Create" : "Sign in"}
          </button>
        </div>
        <button
          className={classes.link}
          onClick={() => setIsRegistrando(!isRegistrando)}
        >
          {isRegistrando
            ? "Already have an account? Sign in"
            : "Don't have an account? Join now"}
        </button>
      </form>
    </div>
  );
};

export default Logueo;
