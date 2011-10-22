function formSubmit(){
  $("form").submit();
  return false;    
}

if (window.location.hash == '#_=_')
window.location.hash = '';