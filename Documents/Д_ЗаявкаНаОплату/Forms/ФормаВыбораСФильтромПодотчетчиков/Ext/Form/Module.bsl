﻿                           
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ТекПП = БюджетныйНаСервере.ПолучитьПредприятия();
	
	РеквизитыПользователя = БюджетныйНаСервере.ВернутьРеквизиты(ПараметрыСеанса.ТекущийПользователь, "ДоступныПредприятияИзСписка, ОграничениеПодразделений, ВидимостьПоСогласованию");  
	
	Список.Параметры.УстановитьЗначениеПараметра("ТекущийПользователь", БПСервер.ПолучитьМассивПользователей());
	Список.Параметры.УстановитьЗначениеПараметра("ВсеПредприятия", НЕ РеквизитыПользователя.ДоступныПредприятияИзСписка);
	Список.Параметры.УстановитьЗначениеПараметра("ДоступныеПредприятия", ТекПП);
	Список.Параметры.УстановитьЗначениеПараметра("ВсеПодразделения", НЕ ПараметрыСеанса.ОграничиватьПодразделения);
	Список.Параметры.УстановитьЗначениеПараметра("ДоступныеПодразделения", ПараметрыСеанса.ДоступныеПодразделения);
	Список.Параметры.УстановитьЗначениеПараметра("ДопСтатьи", ?(ПараметрыСеанса.ТекущийПользователь.ДоступныеСтатьи.Количество(), Истина, Ложь));
	Список.Параметры.УстановитьЗначениеПараметра("ДоступныеСтатьиСырья", ПараметрыСеанса.ТекущийПользователь.ДоступныеСтатьи.ВыгрузитьКолонку("СтатьяДДС"));
	
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
		Список.Параметры.УстановитьЗначениеПараметра("Ознакомлено", Истина);
		Фильтр = "Нет фильтра";
	КонецЕсли;                      //Метаданные.Документы.Д_ЗаявкаНаОплату.Формы.ФормаВыбора1.
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	КонтрагентПриИзменении(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ФильтроватьСерверАвтор()
	//Список.Отбор.Элементы.Очистить();
	Список.Параметры.УстановитьЗначениеПараметра("Авторство", Истина);
	Список.Параметры.УстановитьЗначениеПараметра("Согласовано", Ложь);
	Список.Параметры.УстановитьЗначениеПараметра("ПринадлежностьПредприятию", Ложь);
	Список.Параметры.УстановитьЗначениеПараметра("Оплачено", Ложь);
	Список.Параметры.УстановитьЗначениеПараметра("Ознакомлено", Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ФильтроватьСерверСогласование()
	Список.Параметры.УстановитьЗначениеПараметра("Авторство", Ложь);
	Список.Параметры.УстановитьЗначениеПараметра("Согласовано", Истина);
	Список.Параметры.УстановитьЗначениеПараметра("ПринадлежностьПредприятию", Ложь);
	Список.Параметры.УстановитьЗначениеПараметра("Оплачено", Ложь);
	Список.Параметры.УстановитьЗначениеПараметра("Ознакомлено", Ложь);
КонецПроцедуры

&НаСервере
Процедура ФильтроватьСерверСогласованиеАвтор()
	Список.Параметры.УстановитьЗначениеПараметра("Согласовано", Истина);
	Список.Параметры.УстановитьЗначениеПараметра("ПринадлежностьПредприятию", Ложь);
	Список.Параметры.УстановитьЗначениеПараметра("Оплачено", Истина);
	Список.Параметры.УстановитьЗначениеПараметра("Авторство", Истина);
	Список.Параметры.УстановитьЗначениеПараметра("Ознакомлено", Истина);
КонецПроцедуры

&НаКлиенте
Процедура ФильтроватьСервер()
	Список.Параметры.УстановитьЗначениеПараметра("Авторство", Истина);
	Список.Параметры.УстановитьЗначениеПараметра("Согласовано", Истина);
	Список.Параметры.УстановитьЗначениеПараметра("ПринадлежностьПредприятию", Истина);
	Список.Параметры.УстановитьЗначениеПараметра("Оплачено", Истина);
	Список.Параметры.УстановитьЗначениеПараметра("Ознакомлено", Истина);
КонецПроцедуры

&НаКлиенте
Процедура ФильтроватьСерверОплата()
	Список.Параметры.УстановитьЗначениеПараметра("Авторство", Ложь);
	Список.Параметры.УстановитьЗначениеПараметра("Согласовано", Ложь);
	Список.Параметры.УстановитьЗначениеПараметра("ПринадлежностьПредприятию", Ложь);
	Список.Параметры.УстановитьЗначениеПараметра("Оплачено", Истина);
	Список.Параметры.УстановитьЗначениеПараметра("Ознакомлено", Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ФильтрПриИзменении(Элемент)
	Если Фильтр = "Авторство" Тогда
		ФильтроватьСерверАвтор();
	ИначеЕсли Фильтр = "Согласовано вами" Тогда
		ФильтроватьСерверСогласование();
	ИначеЕсли Фильтр = "Неоплаченные" Тогда
		//ФильтроватьСерверНеоплаченные();
	ИначеЕсли Фильтр = "Оплачено вами" Тогда
		ФильтроватьСерверОплата();
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
		ЗаявкаТЧ.Параметры.УстановитьЗначениеПараметра("Ссылка", Элементы.Список.ТекущаяСтрока);
	Иначе
		Согласование.Параметры.УстановитьЗначениеПараметра("Ссылка", Неопределено);
		ЗаявкаТЧ.Параметры.УстановитьЗначениеПараметра("Ссылка", Неопределено);
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

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)

	Если Элемент = Неопределено И Не ЗначениеЗаполнено(Контрагент) Тогда
		ИспользоватьФильтрКонтрагент = Ложь;
	КонецЕсли;
	
	Элементы.Контрагент.Доступность = ИспользоватьФильтрКонтрагент;
	
	Список.Параметры.УстановитьЗначениеПараметра("Контрагент", Контрагент);   
	Список.Параметры.УстановитьЗначениеПараметра("ВсеКонтрагенты", Не ИспользоватьФильтрКонтрагент);
	Список.Параметры.УстановитьЗначениеПараметра("ВыборПодотчетчика", ВыборПодотчетчика);
	
	//Комментарий к условию запроса дин. списка   КОГДА &ВсеПредприятия Или (&ВыборПодотчетчика И Не &ВсеКонтрагенты):
	//	когда подбираем заявки для авансового отчета по конкретному подотчетчику, показываем заявки "чужих" предприятий,
	//	НО при подборе для платежки "чужие" предприятия уже не показываем
	
КонецПроцедуры

 


