﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Список.Параметры.УстановитьЗначениеПараметра("ДоступныеПредприятия", ПараметрыСеанса.ДоступныеПредприятия);
	БюджетныйНаСервере.ДействияПриСозданииФормыДокумента(ЭтаФорма);
	
	ВидимостьПредприятия = БюджетныйНаСервере.ПолучитьПредприятия().Количество() > 1;
КонецПроцедуры
