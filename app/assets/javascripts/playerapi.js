"use strict";if(typeof muzutv=="undefined")
var muzutv={};muzutv.player={playerObjs:[],defaultInitMethod:"muzuPlayerReady",init:function()
{var allowAutoStart=false;if(typeof muzutv.config!="undefined")
allowAutoStart=muzutv.config.autostartWhenInView;if(window.addEventListener)
{window.addEventListener("message",muzutv.player.receiveMessage);if(allowAutoStart)
window.addEventListener("scroll",muzutv.player.checkForAutoPlay);}
else if(window.attachEvent)
{window.attachEvent("onmessage",muzutv.player.receiveMessage);if(allowAutoStart)
window.attachEvent("onscroll",muzutv.player.checkForAutoPlay);}
else
{try
{console.log("Unable to attach listener");}catch(err){}}
if(typeof muzutv.config!="undefined"&&typeof muzutv.config.onMuzuReady=="function")
muzutv.config.onMuzuReady();else if(typeof onMuzuPlayerAPIReady=="function")
onMuzuPlayerAPIReady();},createPlayer:function(id,options)
{var el=id;if(typeof id=="string")
el=document.getElementById(id);options=options||{};if(el!=null&&el.innerHTML.indexOf("/player/getPlayer/")==-1)
{var src=options.src;if(typeof src=="undefined")
src=muzutv.player.constructSrc(options);else
src=muzutv.player.appendPlayerId(src,options);var frame=document.createElement("iframe");frame.id=options.playerConfig.playerId;frame.width=options.width;frame.height=options.height;frame.src=src;frame.setAttribute("frameborder","0");frame.setAttribute("allowfullscreen",true);if(options.playerConfig.apov=="n")
frame.setAttribute("class","muzu-no-autoplay");el.appendChild(frame);}
else if(el!=null&&el.innerHTML.indexOf("/player/getPlayer/")>-1)
{var src=muzutv.player.constructSrc(options);}},constructSrc:function(options)
{var src=document.location.protocol+"//player.muzu.tv/player/getPlayer/j/"+options.videoId+"/";var items=[];var playerConfig=options.playerConfig||{};options.playerConfig=playerConfig;if(typeof playerConfig.playerId=="undefined")
playerConfig.playerId=muzutv.player.generateId();playerConfig.jse="y";for(var option in playerConfig)
{items.push(option+"="+encodeURIComponent(playerConfig[option]));}
if(items.length>0)
src+="?"+items.join("&");return src;},appendPlayerId:function(src,options)
{var playerConfig=options.playerConfig||{};options.playerConfig=playerConfig;if(typeof playerConfig.playerId=="undefined")
playerConfig.playerId=muzutv.player.generateId();if(src.indexOf("playerId=")==-1)
{if(src.indexOf("?")==-1)
src+="?playerId="+playerConfig.playerId;else
src+="&playerId="+playerConfig.playerId;}
else
{playerConfig.playerId=muzutv.player.getURLParam(location,"playerId");}
return src;},generateId:function()
{var id="";for(var i=0;i<3;i++)
{id+=(((1+Math.random())*0x10000)|0).toString(8).substring(1);}
return"muzuplayer-"+id;},destroy:function()
{muzutv.player.playerObjs=[];},receiveMessage:function(event)
{var message=muzutv.player.validateMessage(event);if(message.parsed)
{var player=muzutv.player.find(message.playerId);try
{player[message.method].apply(player,message.params);}
catch(err)
{if(typeof console!="undefined")
{console.log(err);console.log(message);}}}},validateMessage:function(event)
{var message={method:"",playerId:"",params:[],parsed:false};try
{message=JSON.parse(event.data);if(message!=null&&typeof message.method!="undefined"&&typeof message.playerId!="undefined"&&message.ismuzu)
message.parsed=true;}
catch(err)
{message={method:"",playerId:"",params:[],parsed:false};}
if(message.parsed&&message.method=="muzuPlayerReady")
{var playerObj=new muzutv.player.MuzuPlayer(message.playerId,event.origin,event.source);muzutv.player.assignPlayerId(playerObj.playerId);muzutv.player.playerObjs.push(playerObj);muzutv.player.checkAutoPlay(playerObj);try
{eval(muzutv.player.defaultInitMethod+"('"+message.playerId+"')");}
catch(err)
{if(typeof console!="undefined")
{console.log(err);console.log("no method setup to catch "+muzutv.player.defaultInitMethod);}}
message.parsed=false;}
else if(message.parsed)
{var player=muzutv.player.find(message.playerId);if(player==null||player.origin!=event.origin)
message.parsed=false;}
return message;},sendMessage:function(playerObj,method)
{var params=[];for(var i=2;i<arguments.length;i++)
{params.push(arguments[i]);}
playerObj.source.postMessage(JSON.stringify({ismuzu:true,method:method,params:params}),playerObj.origin);},find:function(playerId)
{var playerObj=null;for(var i=0;i<muzutv.player.playerObjs.length;i++)
{if(muzutv.player.playerObjs[i].playerId==playerId)
{playerObj=muzutv.player.playerObjs[i];break;}}
if(playerObj==null&&muzutv.player.playerObjs.length>0)
playerObj=muzutv.player.playerObjs[0];return playerObj;},MuzuPlayer:function(playerId,origin,source)
{this.playerId=playerId;this.origin=origin;this.source=source;this.events={};this.autoStartWhenInView=false;this.inView=false;this.started=false;this.timesVisible=0;this.checkingAutoPlay=false;},assignPlayerId:function(playerId)
{var el=document.getElementById(playerId);var els=document.getElementsByTagName("iframe");if(el==null)
{for(var i=0;i<els.length;i++)
{var location=els[i].getAttribute("src");var className=els[i].getAttribute("class")||"";if(location!=null&&location.indexOf(".muzu.tv")>-1&&location.indexOf("/player/getPlayer/")>-1&&className.indexOf("muzu-no-autoplay")==-1)
{var id=els[i].getAttribute("id");if(id==null)
{els[i].setAttribute("id",playerId);}
break;}}}},checkAutoPlay:function(playerObj)
{var allowAutoStart=false;if(typeof muzutv.config!="undefined")
allowAutoStart=muzutv.config.autostartWhenInView;if(allowAutoStart)
{var el=document.getElementById(playerObj.playerId);if(el!=null)
{var className=el.getAttribute("class")||"";if(className.indexOf("muzu-no-autoplay")==-1)
playerObj.autoStartWhenInView=true;}
muzutv.player.checkForAutoPlay();}},getURLParam:function(url,paramName)
{var value="";var results=new RegExp('[\\?&]'+paramName+'=([^&#]*)').exec(location);if(results)
value=results[1]||'';return value;},checkForAutoPlay:function(event)
{for(var i=0;i<muzutv.player.playerObjs.length;i++)
{if(!muzutv.player.playerObjs[i].started&&muzutv.player.playerObjs[i].autoStartWhenInView)
{var el=document.getElementById(muzutv.player.playerObjs[i].playerId);if(el!=null)
{if(muzutv.player.isInView(el)&&!muzutv.player.playerObjs[i].checkingAutoPlay)
{muzutv.player.playerObjs[i].checkingAutoPlay=true;var item=muzutv.player.playerObjs[i];setTimeout(function(){muzutv.player.itemStillViewable(item);},200);}}}}},zoomFactor:function()
{var factor=1;if(document.body.getBoundingClientRect)
{var rect=document.body.getBoundingClientRect();var physicalW=rect.right-rect.left;var logicalW=document.body.offsetWidth;factor=Math.round((physicalW/logicalW)*100)/100;}
return factor;},scrollPositions:function()
{var scrollPos={y:0,x:0};if('pageXOffset'in window)
{scrollPos.x=window.pageXOffset;scrollPos.y=window.pageYOffset;}
else
{var zoomFactor=muzutv.player.zoomFactor();scrollPos.x=Math.round(document.documentElement.scrollLeft/zoomFactor);scrollPos.y=Math.round(document.documentElement.scrollTop/zoomFactor);}
return scrollPos;},isInView:function(el)
{var inView=false;var rectOrig=el.getBoundingClientRect();var rect={};if(typeof rectOrig.width=="undefined")
{rect.width=rectOrig.right-rectOrig.left;rect.height=rectOrig.bottom-rectOrig.top;rect.top=rectOrig.top;rect.left=rectOrig.left;}
else
rect=rectOrig;if((rect.top+(rect.height*0.3))>0&&(rect.top+(rect.height*0.7))<document.documentElement.clientHeight)
{if((rect.left+(rect.width*0.3))>0&&(rect.left+(rect.width*0.7))<document.documentElement.clientWidth)
inView=true;}
return inView;},itemStillViewable:function(item)
{var scrollTop=window.scrollY;var scrollLeft=window.scrollX;var el=document.getElementById(item.playerId);if(el!=null)
{if(muzutv.player.isInView(el))
{item.timesVisible+=1;if(item.timesVisible==11)
{item.started=true;item.autoPlayVideo();}
else
{setTimeout(function(){muzutv.player.itemStillViewable(item);},200);}}
else
{item.timesVisible=0;item.checkingAutoPlay=false;}}}};muzutv.player.init();muzutv.player.MuzuPlayer.prototype={constructor:muzutv.player.MuzuPlayer,addEventListener:function(eventName,method)
{if(this.events[eventName]==null)
this.events[eventName]=[];this.events[eventName].push(method);},fireEvent:function(eventName)
{var params=[];for(var i=1;i<arguments.length;i++)
{params.push(arguments[i]);}
if(this.events[eventName]!=null)
{for(var i=0;i<this.events[eventName].length;i++)
{if(typeof this.events[eventName][i]=="string")
eval(this.events[eventName][i])(params);else
this.events[eventName][i].apply(null,params);}}},playVideo:function()
{muzutv.player.sendMessage(this,"playVideo");},autoPlayVideo:function()
{muzutv.player.sendMessage(this,"autoPlayVideo");},pauseVideo:function()
{muzutv.player.sendMessage(this,"pauseVideo");},resumeVideo:function()
{muzutv.player.sendMessage(this,"resumeVideo");},stopVideo:function()
{muzutv.player.sendMessage(this,"stopVideo");},loadVideo:function(videoId)
{muzutv.player.sendMessage(this,"loadVideo",videoId);},getCurrentVideo:function()
{muzutv.player.sendMessage(this,"getCurrentVideo",true);},getPlayerDetails:function()
{muzutv.player.sendMessage(this,"getPlayerDetails",true);},toggleAudio:function()
{muzutv.player.sendMessage(this,"toggleAudio");},setCustomAdParameters:function(params)
{muzutv.player.sendMessage(this,"setCustomAdParameters",params);},setAudioVolume:function(vol)
{muzutv.player.sendMessage(this,"setAudioVolume",vol);},muteVolume:function()
{muzutv.player.sendMessage(this,"muteVolume");},nextTrack:function()
{muzutv.player.sendMessage(this,"nextTrack");},prevTrack:function()
{muzutv.player.sendMessage(this,"prevTrack");},seekTo:function(time)
{muzutv.player.sendMessage(this,"seekTo",time);},changeQuality:function(quality)
{muzutv.player.sendMessage(this,"changeQuality",quality);},getPlayerState:function()
{muzutv.player.sendMessage(this,"getPlayerState",true);},getCurrentTime:function()
{muzutv.player.sendMessage(this,"getCurrentTime",true);},getShuffleMode:function()
{muzutv.player.sendMessage(this,"getShuffleMode",true);},getVideoDuration:function()
{muzutv.player.sendMessage(this,"getVideoDuration",true);},getDownloadPercent:function()
{muzutv.player.sendMessage(this,"getDownloadPercent",true);},shutDown:function()
{muzutv.player.sendMessage(this,"shutDown");},getVideoWidth:function()
{muzutv.player.sendMessage(this,"getVideoWidth",true);},getVideoHeight:function()
{muzutv.player.sendMessage(this,"getVideoHeight",true);},getVideoArea:function()
{muzutv.player.sendMessage(this,"getVideoArea",true);},inskinAdFailed:function(message)
{muzutv.player.sendMessage(this,"inskinAdFailed",message);},inskinAdDisplayed:function()
{muzutv.player.sendMessage(this,"inskinAdDisplayed");},irollAdEnded:function(hasInskin)
{muzutv.player.sendMessage(this,"irollAdEnded",hasInskin);}};
