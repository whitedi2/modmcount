﻿                           
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ЭтоПриказы") Тогда
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ВидСЗ");	
		ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование  = Истина;
		ЭлементОтбора.ПравоеЗначение = Справочники.Д_ВидыВнутреннихДокументов.Приказ;
	КонецЕсли;	
	
	ТекПП = БюджетныйНаСервере.ПолучитьПредприятия();
	
	РеквизитыПользователя = БюджетныйНаСервере.ВернутьРеквизиты(ПараметрыСеанса.ТекущийПользователь, "ДоступныПредприятияИзСписка, ОграничениеПодразделений, ВидимостьПоСогласованию");  
	
	Список.Параметры.УстановитьЗначениеПараметра("ТекущийПользователь", БПСервер.ПолучитьМассивПользователей());
	Список.Параметры.УстановитьЗначениеПараметра("ВсеПредприятия", НЕ РеквизитыПользователя.ДоступныПредприятияИзСписка);
	Список.Параметры.УстановитьЗначениеПараметра("ДоступныеПредприятия", ТекПП);
	Список.Параметры.УстановитьЗначениеПараметра("ВсеПодразделения", НЕ ПараметрыСеанса.ОграничиватьПодразделения);
	Список.Параметры.УстановитьЗначениеПараметра("ДоступныеПодразделения", ПараметрыСеанса.ДоступныеПодразделения);
	Список.Параметры.УстановитьЗначениеПараметра("ВсеЗаявки", РольДоступна("Администратор") ИЛИ РольДоступна("ОФК"));
	//Список.Параметры.УстановитьЗначениеПараметра("ДоступныеСтатьиСырья", ПараметрыСеанса.ТекущийПользователь.ДоступныеСтатьи.ВыгрузитьКолонку("СтатьяДДС"));
	
	Если РеквизитыПользователя.ВидимостьПоСогласованию И НЕ Параметры.Свойство("ТекПлатежка") Тогда
		Элементы.Группа2.Видимость = Ложь;
		ФильтроватьСерверСогласованиеАвтор();
	Иначе
		Если Параметры.Свойство("ТекПлатежка") Тогда
			ТекПлатежка = Параметры.ТекПлатежка;
			Элементы.Группа2.Видимость = Ложь;
		Иначе
			ТекПлатежка = Неопределено ;
		КонецЕсли;
		Список.Параметры.УстановитьЗначениеПараметра("Авторство", Истина);
		Список.Параметры.УстановитьЗначениеПараметра("ПринадлежностьПредприятию", Истина);
		Список.Параметры.УстановитьЗначениеПараметра("Согласовано", Истина);
		Список.Параметры.УстановитьЗначениеПараметра("Оплачено", Истина);
		Список.Параметры.УстановитьЗначениеПараметра("Исполнено", Истина);
		Фильтр = "Нет фильтра";
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ФильтроватьСерверАвтор()
	//Список.Отбор.Элементы.Очистить();
	Список.Параметры.УстановитьЗначениеПараметра("Авторство", Истина);
	Список.Параметры.УстановитьЗначениеПараметра("Согласовано", Ложь);
	Список.Параметры.УстановитьЗначениеПараметра("ПринадлежностьПредприятию", Ложь);
	Список.Параметры.УстановитьЗначениеПараметра("Оплачено", Ложь);
	Список.Параметры.УстановитьЗначениеПараметра("Исполнено", Ложь);
	Список.Параметры.УстановитьЗначениеПараметра("ВсеЗаявки", Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ФильтроватьСерверСогласование()
	Список.Параметры.УстановитьЗначениеПараметра("Авторство", Ложь);
	Список.Параметры.УстановитьЗначениеПараметра("Согласовано", Истина);
	Список.Параметры.УстановитьЗначениеПараметра("ПринадлежностьПредприятию", Ложь);
	Список.Параметры.УстановитьЗначениеПараметра("Оплачено", Ложь);
	Список.Параметры.УстановитьЗначениеПараметра("Исполнено", Ложь);
	Список.Параметры.УстановитьЗначениеПараметра("ВсеЗаявки", Ложь);
КонецПроцедуры

&НаСервере
Процедура ФильтроватьСерверСогласованиеАвтор()
	Список.Параметры.УстановитьЗначениеПараметра("Согласовано", Истина);
	Список.Параметры.УстановитьЗначениеПараметра("ПринадлежностьПредприятию", Ложь);
	Список.Параметры.УстановитьЗначениеПараметра("Оплачено", Истина);
	Список.Параметры.УстановитьЗначениеПараметра("Авторство", Истина);
	Список.Параметры.УстановитьЗначениеПараметра("Исполнено", Истина);
КонецПроцедуры

&НаКлиенте
Процедура ФильтроватьСервер()
	Список.Параметры.УстановитьЗначениеПараметра("Авторство", Истина);
	Список.Параметры.УстановитьЗначениеПараметра("Согласовано", Истина);
	Список.Параметры.УстановитьЗначениеПараметра("ПринадлежностьПредприятию", Истина);
	Список.Параметры.УстановитьЗначениеПараметра("Оплачено", Истина);
	Список.Параметры.УстановитьЗначениеПараметра("Исполнено", Истина);
	Список.Параметры.УстановитьЗначениеПараметра("ВсеЗаявки", БюджетныйНаСервере.РольДоступнаСервер("Администратор") ИЛИ БюджетныйНаСервере.РольДоступнаСервер("ОФК"));
КонецПроцедуры

&НаКлиенте
Процедура ФильтроватьСерверОплата()
	Список.Параметры.УстановитьЗначениеПараметра("Авторство", Ложь);
	Список.Параметры.УстановитьЗначениеПараметра("Согласовано", Ложь);
	Список.Параметры.УстановитьЗначениеПараметра("ПринадлежностьПредприятию", Ложь);
	Список.Параметры.УстановитьЗначениеПараметра("Оплачено", Истина);
	Список.Параметры.УстановитьЗначениеПараметра("Исполнено", Ложь);
	Список.Параметры.УстановитьЗначениеПараметра("ВсеЗаявки", Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ФильтроватьСерверИсполнение()
	Список.Параметры.УстановитьЗначениеПараметра("Авторство", Ложь);
	Список.Параметры.УстановитьЗначениеПараметра("Согласовано", Ложь);
	Список.Параметры.УстановитьЗначениеПараметра("ПринадлежностьПредприятию", Ложь);
	Список.Параметры.УстановитьЗначениеПараметра("Оплачено", Ложь);
	Список.Параметры.УстановитьЗначениеПараметра("Исполнено", Истина);
	Список.Параметры.УстановитьЗначениеПараметра("ВсеЗаявки", Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ФильтрПриИзменении(Элемент)
	Если Фильтр = "Авторство" Тогда
		ФильтроватьСерверАвтор();
	ИначеЕсли Фильтр = "Согласовано вами" Тогда
		ФильтроватьСерверСогласование();
	ИначеЕсли Фильтр = "Неоплаченные" Тогда
		//ФильтроватьСерверНеоплаченные();
	ИначеЕсли Фильтр = "Ознакомление" Тогда
		ФильтроватьСерверОплата();
	ИначеЕсли Фильтр = "Исполненно вами" Тогда
		ФильтроватьСерверИсполнение();
		
	Иначе
		Если БюджетныйНаСервере.ВернутьРеквизит(БюджетныйНаСервере.ПолучитьПользователя(), "ВидимостьПоСогласованию") И НЕ Параметры.Свойство("ТекПлатежка") Тогда
			ФильтроватьСерверСогласованиеАвтор();
		Иначе
			ФильтроватьСервер();
		КонецЕсли;
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	Если НЕ Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Согласование.Параметры.УстановитьЗначениеПараметра("Ссылка", Элементы.Список.ТекущаяСтрока);
		//ЗаявкаТЧ.Параметры.УстановитьЗначениеПараметра("Ссылка", Элементы.Список.ТекущаяСтрока);
	Иначе
		Согласование.Параметры.УстановитьЗначениеПараметра("Ссылка", null);
		//ЗаявкаТЧ.Параметры.УстановитьЗначениеПараметра("Ссылка", Неопределено);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПользовательПриИзменении(Элемент)
	УстановитьПользователя();
КонецПроцедуры

&НаСервере
Процедура УстановитьПользователя()
	ПараметрыСеанса.ТекущийПользователь = Пользователь;
КонецПроцедуры

 


