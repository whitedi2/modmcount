﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Список.Параметры.УстановитьЗначениеПараметра("ТекущееПредприятие", БюджетныйНаСервере.ПолучитьПредприятия());
	//Список.Параметры.УстановитьЗначениеПараметра("Казна", Справочники.Предприятия.Казна);
	Список.Параметры.УстановитьЗначениеПараметра("ДоступныВсеПредприятия", НЕ ПараметрыСеанса.ТекущийПользователь.ДоступныПредприятияИзСписка);
КонецПроцедуры
