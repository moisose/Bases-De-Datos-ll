// required imports
import React, { useEffect, useState } from "react";
import axios from "axios";
import Swal from "sweetalert2";
import withReactContent from "sweetalert2-react-content";
import { show_alert } from "../functions";
import { auth } from "../firebase";
import "firebase/auth";
import { Link } from "react-router-dom";

const ShowFiles = () => {
  // constants

  const url = "https://main-app.ambitiousdune-6b5fa4be.eastus.azurecontainerapps.io/file/list";
  const [files, setFiles] = useState([]);
  const [authUser, setAuthUser] = useState(null);

  // firebase authentification info
  auth.onAuthStateChanged((user) => {
    if (user) {
      const uid = user.uid;
      setAuthUser(user.uid);
      console.log(`El UID del usuario es ${uid}`);
    } else {
      console.log("No hay usuario iniciado sesión");
    }
  });

  // function to get the files from the API
  useEffect(() => {
    getFiles();
  }, []);

  const getFiles = async () => {
    const response = await axios.get(url);
    setFiles(response.data.data);
  };


  // upload files to the blob storage
  // ============

  const handleFileUpload = (event) => {
    // get the selected file from the input
    const file = event.target.files[0];
    // create a new FormData object and append the file to it
    const formData = new FormData();
    formData.append("file", file);
    // make a POST request to the File Upload API with the FormData object and Rapid API headers
    axios
      .post(`https://main-app.ambitiousdune-6b5fa4be.eastus.azurecontainerapps.io/blobstorage/upload/${authUser}`, formData)
      .then((response) => {
		// handle the response
        console.log(response);
        getFiles();
      })
      .catch((error) => {
        // handle errors
        console.log(error);
        // getFiles();
      });

      // getFiles();
  };

  // delete files from the blob storage
  // ============

  const deleteFile= (userId,name,date) =>{
    const MySwal = withReactContent(Swal);
    MySwal.fire({
        title:'¿Seguro de eliminar el file '+name+' ?',
        icon: 'question',text:'No se podrá dar marcha atrás',
        showCancelButton:true,confirmButtonText:'Si, eliminar',cancelButtonText:'Cancelar'
    }).then((result) =>{
        if(result.isConfirmed){
            const urld = `https://main-app.ambitiousdune-6b5fa4be.eastus.azurecontainerapps.io/blobstorage/delete/${userId}/${name}/${date}`;
            axios.delete(urld)
              .then(response => {
                getFiles();
              })
              .catch(error => {
                // Manejar errores
              });
          }
        else{
            show_alert('El file NO fue eliminado','info');
        }
    });
  }

  // download files from the blob storage
  // ============
  const downloadFile= (userId,name,date) =>{
    const MySwal = withReactContent(Swal);
    MySwal.fire({
        title:'¿Seguro de descargr el file '+name+' ?',
        icon: 'question',text:'No se podrá dar marcha atrás',
        showCancelButton:true,confirmButtonText:'Si, descargar',cancelButtonText:'Cancelar'
    }).then((result) =>{
        if(result.isConfirmed){
            const urls = `https://main-app.ambitiousdune-6b5fa4be.eastus.azurecontainerapps.io/blobstorage/download/${userId}/${name}/${date}`;
            console.log(urls)     

            axios(
                  {url: urls, //your url
                  method: 'GET',
                  responseType: 'blob', // important
              }).then((response) => {
                  // create file link in browser's memory
                  const href = URL.createObjectURL(response.data);
              
                  // create "a" HTML element with href to file & click
                  const link = document.createElement('a');
                  link.href = href;
                  link.setAttribute('download', name); //or any other extension
                  document.body.appendChild(link);
                  link.click();
              
                  // clean up "a" element & remove ObjectURL
                  document.body.removeChild(link);
                  URL.revokeObjectURL(href);
              });
          }
        else{
            show_alert('El file NO fue eliminado','info');
        }
    });
  }

  // return the view
  return (
    <div className="App">
        <div className="container-fluid">
          <div className="row mt-3">
            <div className="col-md-4 offset-md-4">
              <div className="logout_button">
                {/* button for log out */}
                <Link
                  style={{ color: "white", textDecoration: "underline" }}
                  to="/"
                >
                  <button className="btn btn-dark" >Log Out</button>
                </Link>

                {/* Input for upload the file */}
                <input type="file" onChange={handleFileUpload} />
              </div>
            </div>
          </div>
          <div className="row mt-3">
            <div className="col-12 col-lg-8 offset-0 offset-lg-2">
              <div className="table-responsive">
                <table className="table table-bordered" style={{width: '100%'}}>
                  <thead>
                    {/* these are the headers of the table */}
                    <tr><th>Id</th><th>File</th><th>ModificationD</th></tr>
                  </thead>
                  <tbody className="table-group-divider">
                  {files.map((file,i)=>(
                    <tr key={file.fileId}>
                      {/* <td>{(i+1)}</td> */}
                      <td>{file.fileId}</td>
                      <td>{file.name}</td>
                      {/* <td>{file.description}</td> */}
                      {/* <td>{file.periodId}</td> */}
                      {/* <td>{file.creationDate}</td> */}
                      <td>{file.modificationDate}</td>
                      <td>
                        {/* buttons for download and delete */}
                        <button onClick={()=>downloadFile(file.userId,file.name,file.modificationDate)} className="btn btn-download">
                          <i className="fa-solid fa-download"></i>
                        </button>
                        &nbsp;
                        <button onClick={()=>deleteFile(file.userId,file.name,file.modificationDate)} className='btn btn-danger'>
                          <i className="fa-solid fa-trash"></i>
                        </button>
                      </td>
                    </tr>
                  ))
                  } 
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
    </div>
  )
};

export default ShowFiles;