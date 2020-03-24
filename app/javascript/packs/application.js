import "bootstrap";
import { displayRoute } from '../plugins/displaySegment';
import { fixFooter } from '../plugins/footer';
import { navbarShow } from '../plugins/navbarShow';
import { navbar } from '../plugins/navbar';

fixFooter();
displayRoute();
navbar();
navbarShow();
