//          Common API BASEURL      //

//                Saravanan IP Local
// var baseURL = 'http://192.168.0.100:8000/api/';

//                Local
var baseURL = 'http://127.0.0.1:8000/api/';
var webURL = 'http://127.0.0.1:8000/';
//                Test server
// var baseURL = 'http://skypad.in/test/api/';

//                Live server
// var baseURL = 'http://skypad.in/test/api/';

//                AWS IP Test server
// var baseURL = 'http://3.109.61.187/test/api/';

var LOGIN = '${baseURL}admin/login';
var LOGOUT = '${baseURL}admin/logout';
var ADD_EXPENSES = '${baseURL}expense/store';
var LIST_EXPENSES = '${baseURL}expense/view';
var DASHBOARD = '${baseURL}admin/dashboard/';
var PROFILE = '${baseURL}admin/profile';
var PROFILE_IMAGE = '${webURL}upload/admin_images';
var EDIT_PROFILE = '${baseURL}admin/profile/store';
var EDITEXPENSE = '${baseURL}expense/edit';
var EXPENSEUPDATE = '${baseURL}expense/update';
var EXPENSEDELETE = '${baseURL}expense/delete';
var PAYMENT_LISTVIEW = '${baseURL}payment/view_list';
var LEAVES_VIEW = '${baseURL}leave/view';
var ADD_LEAVE = '${baseURL}leave/store';
var LEAVE_EDIT = '${baseURL}leave/edit';
var LEAVE_UPDATE = '${baseURL}leave/update';
var LEAVE_DELETE = '${baseURL}leave/delete';
var ADD_TIMESHET = '${baseURL}project/full-calender/action';
var TIMESHEET_VIEW = '${baseURL}project/full-calender';
