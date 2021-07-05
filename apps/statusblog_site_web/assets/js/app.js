// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"

import tippy from 'tippy.js';
import 'tippy.js/dist/tippy.css';
import 'tippy.js/themes/light-border.css';

function secondsToHms(d) {
  d = Number(d);
  var h = Math.floor(d / 3600);
  var m = Math.floor(d % 3600 / 60);
  var s = Math.floor(d % 3600 % 60);

  var hDisplay = h > 0 ? h + (h == 1 ? " hour, " : " hours, ") : "";
  var mDisplay = m > 0 ? m + (m == 1 ? " minute, " : " minutes, ") : "";
  var sDisplay = s > 0 ? s + (s == 1 ? " second" : " seconds") : "";
  return hDisplay + mDisplay + sDisplay; 
}

tippy('.uptime-day', {
  placement: 'bottom',
  theme: 'light-border',
  allowHTML: true,
  //interactive: true,
  content: (reference) => {
    const majorOutageSeconds = Number.parseInt(reference.getAttribute("data-major-outage-seconds"))
    const partialOutageSeconds = Number.parseInt(reference.getAttribute("data-partial-outage-seconds"))
    const date = reference.getAttribute("data-date")

    let secondary = '<div>No downtime recorded on this day</div>'
    if (majorOutageSeconds || partialOutageSeconds) {
      secondary = "<div>"
      if (majorOutageSeconds) {
        secondary += `<div>${secondsToHms(majorOutageSeconds)} of major outage</div>`
      }
      if (partialOutageSeconds) {
        var myDate = new Date().toTimeString().replace(/.*(\d{2}:\d{2}:\d{2}).*/, "$1");
        secondary += `<div>${secondsToHms(partialOutageSeconds)} of partial outage</div>`
      }
      secondary += '</div>'
    } else if (reference.getAttribute('data-empty-day') === "true") {
      secondary = "<div>No data exists for this day</day>"
    }

    return `
    <div>
      <strong>${date}</strong>
      ${secondary}
    </div>
    `
  }
});
