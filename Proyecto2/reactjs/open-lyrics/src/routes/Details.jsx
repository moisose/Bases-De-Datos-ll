import React, { useEffect } from "react";
import { Link } from "react-router-dom";
import classes from "./Details.module.css";
import { useState } from "react";

function Details() {
  const [artist, setArtist] = useState("");
  //   const [genres, setGenres] = useState("");
  const [songs, setSongs] = useState("");
  const [link, setLink] = useState("");
  const [songName, setSongName] = useState("");
  const [lyric, setLyric] = useState("");

  // load the lyric and replace the next line character with <br>
  useEffect(() => {
    // aqui va fetch
    setLyric(
      "He ain't fly, no\nHe don't even drive, no\nThat's why you're calling my phone\nAnd won't leave me alone\nHe ain't even fly, though\nYou ain't gotta lie, no\nThat's why you're calling my phone\nAnd you're wanting me to get, get, get it\nBeat, beat, beat it\nBeat, beat, beat it\nYou want me to beat, beat, beat it\nBeat, beat, beat it\nBeat, beat, beat it\nNot a problem baby\nBeat, beat, beat it\nBeat, beat, beat it\nYou want me to beat, beat\nBeat, beat, beat it\nBeat, beat, beat it\nBeat, beat\n\nI've been out here looking for a girl like you\nSo already settle down and loyal to your dude\nYou got your eyes on me and girl\nHe got his eyes on you\nMy eyes are on this money\nAnd it's nothing he can do\n\nHe ain't fly, no\nHe don't even drive, no\nThat's why you're calling my phone\nAnd won't leave me alone\nHe ain't even fly, though\nYou ain't gotta lie, no\nThat's why you're calling my phone\nAnd you're wanting me to get, get, get it\nBeat, beat, beat it\nBeat, beat, beat it\nYou want me to beat, beat, beat it\nBeat, beat, beat it\nBeat, beat, beat it\nNot a problem baby\nBeat, beat, beat it\nBeat, beat, beat it\nYou want me to beat, beat\nBeat, beat, beat it\nBeat, beat, beat it\nBeat, beat\n\nYou've been out here looking for a guy like me\nAnd I ain't never settle down, just loyal to my team\nYou got your eyes on me and girl\nI got my eyes on green\nYour nigga he so bummy\nNeeds to boost his self esteem\n\nHe ain't fly, no\nHe don't even drive, no\nThat's why you're calling my phone\nAnd won't leave me alone\nHe ain't even fly, though\nYou ain't gotta lie, no\nThat's why you're calling my phone\nAnd you're wanting me to get, get, get it\nBeat, beat, beat it\nBeat, beat, beat it\nYou want me to beat, beat, beat it\nBeat, beat, beat it\nBeat, beat, beat it\nNot a problem baby\nBeat, beat, beat it\nBeat, beat, beat it\nYou want me to beat, beat\nBeat, beat, beat it\nBeat, beat, beat it\nBeat, beat\n\nUgh, you say you want a fly nigga\nRoll somethin' and get high nigga\nI spendin' all the most and if he aint coming close\nThen its time to tell him bye\nI'll take you up in the sky\nWe'll be floatin'\nGet you wet\nLike the ocean\nI'ma speed up on it, if your pussy was a book\nI would read up on it\nGirl im just trying to get you back to my crib\nSeen all them Instagram pictures you post\nSo I already know what it is\nTalk to me now\n\nHe ain't fly, no\nHe don't even drive, no\nThat's why you're calling my phone\nAnd won't leave me alone\nHe ain't even fly, though\nYou ain't gotta lie, no\nThat's why you're calling my phone\nAnd you're wanting me to get, get, get it\nBeat, beat, beat it\nBeat, beat, beat it\nYou want me to beat, beat, beat it\nBeat, beat, beat it\nBeat, beat, beat it\nNot a problem baby\nBeat, beat, beat it\nBeat, beat, beat it\nYou want me to beat, beat\nBeat, beat, beat it\nBeat, beat, beat it\nBeat, beat"
    );
    const regex = /\\n|\\r\\n|\\n\\r|\\r/g;
    lyric.replace(regex, "<br>");
  }, []);

  return (
    <>
      {/* <h1>Details</h1> */}
      <div className={classes.container}>
        <Link to="/home">
          <img className={classes.arrow} src="/back.png" alt="back arrow" />
        </Link>
        <img className={classes.logo} src="/whitelogo.png" alt="logo" />

        <h1 className={classes.artist}>Amy Winehouse</h1>
        <p className={classes.details}>
          <strong>R&B - JAZZ - SOUL MUSIC</strong>
        </p>
        <p className={classes.details}>
          <strong>70 SONGS</strong>
        </p>
        <p className={classes.details}>
          <strong>Popularity:</strong> 13.5
        </p>
        <p className={classes.details}>
          <strong>Link:</strong> /amy-winehose/
        </p>
      </div>
      <h2>You Know I'm no Good (remix)</h2>
      <div className={classes.column}>
        <span className={classes.lyric}>{lyric}</span>
      </div>
    </>
  );
}

export default Details;
