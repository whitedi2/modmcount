﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Заголовок = "Список задач / " + ПараметрыСеанса.ТекущийПользователь;
	Список.Параметры.УстановитьЗначениеПараметра("ТекущееПредприятие", БюджетныйНаСервере.ПолучитьПредприятия());
	Список.Параметры.УстановитьЗначениеПараметра("ЭтоАдмин", БюджетныйНаСервере.РольАдминаДоступнаСервер());
КонецПроцедуры
