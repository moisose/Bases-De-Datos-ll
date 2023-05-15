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
        <p className={classes.lyric}>
          [Amy winehouse] Meet you downstairs in the bar and heard your rolled
          up sleeves and your skull t-shirt You say why did you do it with him
          today? and sniff me out like I was tangueray [Ghostface killah] why
          you actin' like youre more trouble than toney starks'n you need to
          just walk away like kelly clarkson I know. we were free to sleep
          around town but I figured you said that cuz how I get down now of
          course, you were out there messin' around I would've told you once you
          ghost you never go back try gee'n me like I dont know how to mack I'm
          a don and top of the line I stay fly and stop tryin' to keep coverin'
          the lies and using my credit cards to buy diamonds we need to
          straighten this out get to the bottom of it all lets go before we
          start the war begin with two reasons why we need to talk and stop
          poppin up in my cribs all over new york and death stalkin' you such
          trouble and no good them fightin' words in my block and we in the hood
          [amy winehouse] I cheated myself like I knew I would I told ya, I was
          troubled you know that im no good [ghostface killah] You had to be a
          nasty girl and try to play me Play me, play me, play me... nasty girl,
          nasty girl, nasty girl yeah, yo, yo a-yo I knew you was trouble when I
          first layed eyes on you temperature so hot the heat just rise with you
          lemmee ride with you, talk about your mistakes you cheated yourself
          but these are the breaks and it'll never be the same again cause of
          old boy but oh boy, together we make so much joy in the sands'n oh
          what a web we weave but you played me so I had to roll up my sleeves
          and hunt you down holding the next man's stacks now you sorry and
          trying to bring that old thing back act like we can rekindle that
          flame It's a shame how you cant get me off the brain he that lame you
          love how I bring the pain got them rug burns stinging and you saying
          my name say my name, uh thats right im high post Get the champagne
          love, word up we gonna toast [amy winehouse] I cheated myself like I
          knew I would I told ya, I was troubled you know that im no good
          [ghostface killah] You had to be a nasty girl and try to play me nasty
          girl,girl you can't leave the kid you can't leave the kid don't worry
          im gonna be around forever nasty girl don't forget it imma be around
          forever don't forget it imma be around forever [amy winehouse] sweet
          reunion, jamaica and spain were like how we were again I'm in the tub
          youre on the seat lick your lips as I soak my feet [ghostface killah]
          Yo, get to bath and bodyworks pumpin the spice cream together like
          cheech and chong we make nice dreams these fight scenes I take the
          good with the bad cause you give the best brains that ive ever had
          anything worth having is hard to keep I love you like my coffee so hot
          and so sweet so lets stick it out so we never regret it I could
          forgive the past but I never forget it [amy winehouse] I cheated
          myself like I knew I would I told ya I was troubled you know that im
          no good I cheated myself like I knew I would I told ya I was troubled
          yeah ya know that im no good [ghostface killah] I could forgive the
          past but I never forget it nasty girl, nasty girl try to play me nasty
          girl you had to be a nasty girl and try to play me nasty girl try to
          play me, try to play me nasty girl I could forgive the past but I
          never forget it
        </p>
      </div>
    </>
  );
}

export default Details;
