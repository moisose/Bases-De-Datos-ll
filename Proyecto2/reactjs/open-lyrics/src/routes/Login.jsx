import { Link, Outlet } from "react-router-dom";
import React, { useEffect } from "react";
import { firebaseProperties } from "../fb";
import Logueo from "./Logueo";
import { useNavigate } from "react-router-dom";
import Home from "./Home";

// import classes from "./Login.module.css";

function Login() {
  const navigate = useNavigate();
  const [usuario, setUsuario] = React.useState(null);

  useEffect(() => {
    firebaseProperties.auth().onAuthStateChanged((usuarioFirebase) => {
      console.log("ya tienes sesión iniciada con:", usuarioFirebase);
      setUsuario(usuarioFirebase);
    });
  }, []);

  const cerrarSesion = () => {
    firebaseProperties.auth().signOut();
  };

  return (
    <>
      <Outlet />
      {cerrarSesion()}
      {usuario ? navigate("/home") : <Logueo setUsuario={setUsuario} />}
    </>
  );
}

export default Login;
