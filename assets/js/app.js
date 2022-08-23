import Alpine from "alpinejs";
// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";

import "../css/app.css";
import "./user_socket.js";

window.Alpine = Alpine;
Alpine.start();
