import React, { useEffect } from "react";
import { Link } from "react-router-dom";
import classes from "./Details.module.css";
import { useState } from "react";
import { useLocation } from "react-router-dom";
// import { jsonData } from "../components/SearchResult";

import * as Constants from "../constants";

function Details() {
  const [artist, setArtist] = useState("");
  //   const [genres, setGenres] = useState("");
  const [songs, setSongs] = useState("");
  const [link, setLink] = useState("");
  const [songName, setSongName] = useState("");
  const [lyric, setLyric] = useState("");
  const [data, setData] = useState([]);
  const location = useLocation();

  // Get data passed by Link-State in SearchResult and converting the data object to string
  useEffect(() => {
    setLink(JSON.parse(location.state.info));
  }, []);

  //Fetch to get the data need it to use in this .jsx 
  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await fetch('https://mocki.io/v1/bf59beb2-cf62-4adb-98a2-d7eeccd29621'); // + link.slice(-1)
        const jsonData = await response.json();
        setData(jsonData);
      } catch (error) {
        console.log(error);
      }
    };
    fetchData();
  }, []);
  
  // useEffect(() => {
  //   setLyric(data.fragment);
  // }, [data]);
  
  return (
    <>
      {/* <h1>Details</h1> */}
      <div className={classes.container}>
        <Link to={Constants.homeRoute}>
          <img
            className={classes.arrow}
            src={Constants.backImg}
            alt="back arrow"
          />
        </Link>
        <img className={classes.logo} src={Constants.detailsLogo} alt="logo" />

        <h1 className={classes.artist}>Amy Winehouse</h1>
        <p className={classes.details}>
          <strong>{data.genres.join(' - ')}</strong>
        </p>
        <p className={classes.details}>
          <strong>{data.songs} Songs</strong>
        </p>
        <p className={classes.details}>
          <strong>Popularity:</strong> {data.popularity}
        </p>
        <p className={classes.details}>
          <strong>Link:</strong> {link}
        </p>
      </div>
      <h2>{data.title}</h2>
      <div className={classes.column}>
        <span className={classes.lyric}>{data.lyrics}</span>
      </div>
    </>
  );
}

export default Details;
