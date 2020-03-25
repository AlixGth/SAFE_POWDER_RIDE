import "bootstrap";
import { displayRoute } from '../plugins/displaySegment';
import { fixFooter } from '../plugins/footer';
import { filtersRisks } from '../plugins/filters';
import { navbar, navbarShow } from '../plugins/navbar';

fixFooter();
navbar();


if (document.getElementById("map")) {
  displayRoute();
  navbarShow();
}

// filtersRisks();

