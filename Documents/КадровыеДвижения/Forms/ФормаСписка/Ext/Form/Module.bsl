﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Список.Параметры.УстановитьЗначениеПараметра("Предприятие", Справочники.Предприятия.ПустаяСсылка());
	Список.Параметры.УстановитьЗначениеПараметра("ЮрЛицо", Справочники.Организации.ПустаяСсылка());
	
КонецПроцедуры

&НаКлиенте
Процедура ПредприятиеПриИзменении(Элемент)
	
	Список.Параметры.УстановитьЗначениеПараметра("Предприятие", Предприятие);
	Список.Параметры.УстановитьЗначениеПараметра("ЮрЛицо", ЮрЛицо);
	
КонецПроцедуры

&НаКлиенте
Процедура ЮрЛицоПриИзменении(Элемент)
	
	Список.Параметры.УстановитьЗначениеПараметра("Предприятие", Предприятие);
	Список.Параметры.УстановитьЗначениеПараметра("ЮрЛицо", ЮрЛицо);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Пользователь", БюджетныйНаСервере.ПолучитьПользователя()));
	
КонецПроцедуры
