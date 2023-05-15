import React from "react";
import { Link } from "react-router-dom";
import { firebaseProperties } from "../fb";

const Home = () => {
  const cerrarSesion = () => {
    firebaseProperties.auth().signOut();
  };
  return (
    <div>
      <h1>BUSCADOR MIEO.</h1>
      <Link to="/" onClick={cerrarSesion}>
        Cerrar sesión
      </Link>
      {/* <button onClick={cerrarSesion}>Cerrar Sesión</button> */}
    </div>
  );
};

export default Home;
