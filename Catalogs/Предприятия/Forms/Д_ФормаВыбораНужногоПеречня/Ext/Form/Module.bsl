﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//МассивПП = БюджетныйНаСервере.ПолучитьПредприятия(Параметры.Свойство("Флаг"));
	//Список.Параметры.УстановитьЗначениеПараметра("ТекущееПредприятие", МассивПП);
	//Список.Параметры.УстановитьЗначениеПараметра("ОтображатьВсеПредприятия", Ложь);
	//Если МассивПП.Количество() < 10 Тогда
	//	Элементы.Список.Отображение = ОтображениеТаблицы.Список;
	//КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ПоказыватьВсеПредприятияПриИзменении(Элемент)
	
	//Список.Параметры.УстановитьЗначениеПараметра("ОтображатьВсеПредприятия", ПоказыватьВсеПредприятия);
	//Элементы.Список.Обновить();
	
КонецПроцедуры

