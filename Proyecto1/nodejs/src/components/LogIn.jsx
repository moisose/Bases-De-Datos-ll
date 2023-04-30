import { signInWithEmailAndPassword } from "firebase/auth";
import React, { useState } from "react";
import { auth } from "../firebase";
import "firebase/auth";
import "./LogIn.css";

import { Link } from "react-router-dom";

const LogIn = () => {
  // constants for authentication
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loggedIn, setLoggedIn] = useState(false);
  const [authUser, setAuthUser] = useState(null);

  // login information
  const logIn = (e) => {
    e.preventDefault();
    signInWithEmailAndPassword(auth, email, password)
      .then((userCredential) => {
        console.log(userCredential);

        auth.onAuthStateChanged((user) => {
          if (user) {
            const uid = user.uid;
            setAuthUser(user.uid);
            console.log(`El UID del usuario es ${uid}`);
          } else {
            console.log("No hay usuario iniciado sesión");
          }
        });

        setLoggedIn(true);
      })
      .catch((error) => {
        console.log(error);
      });
  };

  // return the view
  return (
    <div className="log-in-container">
      <h2>Login</h2>
      <form className="login-form" onSubmit={logIn}>
        <label htmlFor="email">email</label>
        <input
          type="email"
          placeholder="Enter your email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        ></input>
        <label htmlFor="password">password</label>
        <input
          type="password"
          placeholder="Enter your password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
        ></input>
        {/* this is a case, if is not loged in, the button is Log IN, otherwise is Go to home */}
        {loggedIn && (
          <Link
            style={{ color: "white", textDecoration: "underline" }}
            to="/home"
          >
            <button type="submit">Go to home page →</button>
            <p>{`Signed In as ${authUser}`}</p>
          </Link>
        )}
        {!loggedIn && <button type="submit">Login</button>}
      </form>
    </div>
  );
};

export default LogIn;
