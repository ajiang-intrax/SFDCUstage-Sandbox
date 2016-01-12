@charset "UTF-8";
/* CSS Document */

/* Begin Reset Styles */

html, body, div, span, applet, object, iframe,
h1, h2, h3, h4, h5, h6, p, blockquote, pre,
a, abbr, acronym, address, big, cite, code,
del, dfn, em, img, ins, kbd, q, s, samp,
small, strike, strong, sub, sup, tt, var,
b, u, i, center,
dl, dt, dd, ol, ul, li,
fieldset, form, label, legend,
table, caption, tbody, tfoot, thead, tr, th, td,
article, aside, canvas, details, embed, 
figure, figcaption, footer, header, hgroup, 
menu, nav, output, ruby, section, summary,
time, mark, audio, video {
	margin: 0;
	padding: 0;
	border: 0;
	font-size: 100%;
	font-family:"Trebuchet MS", Arial, Helvetica, sans-serif;
	vertical-align: baseline;
}
/* HTML5 display-role reset for older browsers */
article, aside, details, figcaption, figure, 
footer, header, hgroup, menu, nav, section, h1, h2, h3, h4, h5, h6, div, p {
	display: block;
}
body {
	line-height: 1;
}
ol, ul {
	list-style: none;
}
blockquote, q {
	quotes: none;
}
blockquote:before, blockquote:after,
q:before, q:after {
	content: '';
	content: none;
}
table {
	border-collapse: collapse;
	border-spacing: 0;
}

/* End Reset Styles */

#intrax-logo {float:left;}
#new-user-links, #current-user-links {
    float: right;
    padding-top: 20px;
}

body{font-size:13px; font-family:"Trebuchet MS", Arial, sans-serif; }
 
#wrapper, #global-header {clear:both; margin:20px auto; width:80%; min-width:500px;}
#global-header {height:60px;}

.view-block{background: none repeat scroll 0 0 #E5EFBD;
    border: 10px solid #F2F6E5;
    padding: 30px 20px;
	clear:both;}
	
.intrax-form-title{color:#202020; display: block; font-size: 21px; float:left; margin-bottom: 20px;}
 
.bPageBlock .labelCol, .bPageBlock .labelCol a {
    color:#333333;
        font-family: "Trebuchet MS", Arial,sans-serif;
        font-size:15px;
        font-weight:bold;
        padding:10px 5px;
        line-height:1.2em;
        vertical-align: top;}
		
body .primaryPalette, body .primaryPalette a, body .bPageTitle .secondaryPalette, body .bPageTitle .secondaryPalette a, body .secondaryPalette .lbHeader, body .secondaryPalette .lbHeader a, body .pbSubheader, body .pbSubheader a {
    font-family: "Trebuchet MS", Arial,Helvetica,sans-serif;
}		

.primaryPalette, .secondaryPalette, .tertiaryPalette, .individualPalette .primaryPalette, .individualPalette .secondaryPalette, .individualPalette .tertiaryPalette, .bPageBlock .pbFooter {
    background-color: #F2F6E5;
}

.bPageBlock .detailList tr td, .bPageBlock .detailList tr th {
    border-bottom: none;
}


.pbSubheader img {float:left;}
.pbSubheader {padding:10px;}
 
.editPage .bPageBlock .detailList tr td, .editPage .bPageBlock .detailList tr th {
    border-bottom: medium none;
    padding-bottom: 15px;
}

.apexp .detailList .list td, .apexp .detailList .list th, .apexp .editPage .bPageBlock .detailList .list tr td, .apexp .editPage .bPageBlock .detailList .list tr th {
    border-bottom: 1px solid #E3DEB8;
    color: #333333;
    padding: 10px 2px 10px 5px;
}

.bPageBlock .pbBody {
    padding: 10px 20px;
}
 
.bEditBlock input, .bEditBlock select, .bEditBlock img, .quickCreateModule input, .quickCreateModule select, .quickCreateModule img {
    margin-right: 0.25em;
    padding: 5px;
    vertical-align: middle;
}
 
.bPageBlock .pbHeader {
    background-color: transparent;
}
 
.detailPage .bPageBlock, .editPage .bPageBlock {
background: none repeat scroll 0 0 #E5EFBD;
    border: 10px solid #F2F6E5;
    padding: 30px 20px;
}
 
.bPageBlock, .individualPalette .bPageBlock {
    background-color: transparent;
    border-style: none;
} 
 
.btnGo, .btnImportant, .btnSharing, .btnDisabled, .btn, .bEditBlock .btnGo, .bEditBlock .btnImportant, .bEditBlock .btnSharing, .bEditBlock .btnDisabled, .bEditBlock .btn, .btnCustomAction, .btnOverriddenAction {
     background: none repeat scroll 0 0 #7C192E;
    border: medium none;
    color: white;
    font-size: 12px;
    margin: 0 2px;
    padding: 6px 8px;
}
 
.picklistArrowRight {
    background-repeat: no-repeat;
}
 
.picklistArrowLeft {
    background-repeat: no-repeat;
}
 
.multiSelectPicklistTable .multiSelectPicklistRow .multiSelectPicklistCell {
    background-color:transparent;
}
 
.bPageBlock .detailList .dataCol {
    font-size: 15px;
    padding-top: 10px;
	padding-bottom:10px;
}
 
p{margin-bottom:10px;}
 

.progress-bar{display: block; font-size: 21px; display:block; float:right; margin-bottom: 20px;}
 
 
/* Login Page, Registration, Password Styles */
 
#login-box{
background: none repeat scroll 0 0 #E5EFBD;
    border: 10px solid #F2F6E5;
    padding: 30px 30px;
        }
#login-box h1{font-size:21px; margin-bottom:20px;}
 
#login-box form td{padding-bottom:10px;}
#login-box form label {padding-right:20px; font-size:15px; font-weight:bold;}
#login-box form input {padding:5px;}

/* Begin Error Message Styles */

.message {
    margin: 20px 0;}
.messageTable li {margin:0 0 10px 0;}	

/* End Error Message Styles */
