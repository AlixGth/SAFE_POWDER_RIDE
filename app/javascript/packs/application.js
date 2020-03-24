import "bootstrap";
import { displayRoute } from '../plugins/displaySegment';
import { fixFooter } from '../plugins/footer';
import { navbar } from '../plugins/navbar';

fixFooter();
displayRoute();
navbar();
