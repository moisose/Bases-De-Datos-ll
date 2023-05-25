import classes from "./Pagination.module.css";

import "./Pagination.module.css";

// is responsible for managing the pagination of
// the results dividing them into separate pages
const Pagination = ({
  totalPosts,
  postsPerPage,
  setCurrentPage,
  currentPage,
}) => {
  let pages = [];

  const totalPages = Math.ceil(totalPosts / postsPerPage);

  // Número de páginas a mostrar antes y después de los puntos suspensivos
  const visiblePages = 2;

  if (totalPages <= visiblePages + 2) {
    // Mostrar todas las páginas si no hay suficientes páginas para mostrar con puntos suspensivos
    for (let i = 1; i <= totalPages; i++) {
      pages.push(i);
    }
  } else {
    const currentPageIndex = currentPage;

    // Agregar página inicial
    pages.push(1);

    // Agregar páginas antes de los puntos suspensivos
    let startPage = Math.max(2, currentPageIndex - visiblePages);
    let endPage = Math.min(startPage + visiblePages * 2, totalPages - 1);

    if (startPage > 2) {
      pages.push("...");
    }

    for (let i = startPage; i <= endPage; i++) {
      pages.push(i);
    }

    // Agregar puntos suspensivos si hay páginas después del número actual
    if (endPage < totalPages - 1) {
      pages.push("...");
    }

    // Agregar página final
    pages.push(totalPages);
  }

  return (
    <div className={classes.pagination}>
      {pages.map((page, index) => (
        <button
          key={index}
          onClick={
            page === "..."
              ? () => {
                  // setCurrentPage(currentPage + 1);
                  // window.scrollTo({
                  //   top: 0,
                  //   behavior: 'smooth',
                  // });
                }
              : () => {
                  setCurrentPage(page);
                  window.scrollTo({
                    top: 0,
                    behavior: "smooth",
                  });
                }
          }
          className={page === currentPage ? classes.active : ""}
        >
          {page}
        </button>
      ))}
    </div>
  );
};

export default Pagination;
