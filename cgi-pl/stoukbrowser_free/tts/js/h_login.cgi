<script language="JavaScript">
//Free JavaScripts on http://www.ScriptBreaker.com
function newWindow(mypage,myname,w,h,features) {
  if(screen.width){
  var winl = (screen.width-w)/2;
  var wint = (screen.height-h)/2;
  }else{winl = 0;wint =0;}
  if (winl < 0) winl = 0;
  if (wint < 0) wint = 0;
  var settings = 'height=' + h + ',';
  settings += 'width=' + w + ',';
  settings += 'top=' + wint + ',';
  settings += 'left=' + winl + ',';
  settings += features;
  win = window.open(mypage,myname,settings);
  win.window.focus();
}
</script>