if (window.location.pathname === "/test" || window.location.pathname.startsWith("/test/")) {
  document.title = "Deadline Engine Inspector";
  import("./testbench.js");
} else {
  import("./main.js");
}
