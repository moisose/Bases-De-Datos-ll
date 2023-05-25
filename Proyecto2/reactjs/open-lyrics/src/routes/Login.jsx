import { Outlet, useNavigate } from "react-router-dom";
import React, { useEffect } from "react";
import { firebaseProperties } from "../fb";
import Logueo from "./Logueo";

// style
import * as Constants from "../constants";

function Login() {
  const navigate = useNavigate();
  const [usuario, setUsuario] = React.useState(null);

  // handles the login action
  useEffect(() => {
    firebaseProperties.auth().onAuthStateChanged((usuarioFirebase) => {
      console.log("you are already logged in with:", usuarioFirebase);
      setUsuario(usuarioFirebase);
    });
  }, []);

  // handles logout
  const logOut = () => {
    firebaseProperties.auth().signOut();
  };

  // handles the navigation to the home page
  useEffect(() => {
    if (usuario) {
      navigate(Constants.homeRoute);
    }
  }, [usuario, navigate]);

  return (
    <>
      <Outlet />
      {logOut()}
      {!usuario && <Logueo setUsuario={setUsuario} />}
    </>
  );
}

export default Login;
