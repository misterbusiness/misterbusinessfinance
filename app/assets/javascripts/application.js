// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .
//= require select2
//= require rails.validations

JQuery.fn.parcela = function(numParcelas, freqParcela, valor, dataVencimento){
	switch(freqParcela){
		case 'Mensal': return 2 ;break;
		case 'Semanal': return 1 ;break;
		case 'Semestral': return 3;break;
		case 'Anual': return 4;break;
	}
}
