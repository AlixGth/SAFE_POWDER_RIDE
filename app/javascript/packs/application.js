import "bootstrap";
import { displayRoute } from '../plugins/displaySegment';
import { fixFooter } from '../plugins/footer';
import { navbar, navbarShow } from '../plugins/navbar';

fixFooter();
navbar();
displayRoute();
navbarShow();
