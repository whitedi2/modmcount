﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Список.Параметры.УстановитьЗначениеПараметра("ДоступныеПредприятия", ПараметрыСеанса.ДоступныеПредприятия);
	БюджетныйНаСервере.ДействияПриСозданииФормыДокумента(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
КонецПроцедуры
