﻿
&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	СписокБанковскихСчетов.Отбор.Элементы.Очистить();
	
	Если Не Элементы.Список.ТекущиеДанные = Неопределено Тогда
		
		НовыйОтбор = СписокБанковскихСчетов.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("БанковскиеСчетаВладелец");
		НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		НовыйОтбор.ПравоеЗначение = Элементы.Список.ТекущиеДанные.Организация;
		
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьВыделенныеПредприятиемИОтветственным(Команда)
	ПодборОтветственного();
КонецПроцедуры

&НаКлиенте
Процедура ПодборОтветственного()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Истина);
	
	ФП = ПолучитьФорму("Справочник.Пользователи.Форма.УУ_ФормаВыбора", ПараметрыФормы, ЭтаФорма);
	ФП.Открыть();

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Для каждого Строка Из Элементы.СписокБанковскихСчетов.ВыделенныеСтроки Цикл
		ИзменитьБанковскийСчет(Строка,ВыбранноеЗначение);
	КонецЦикла;
	
	СписокПриАктивизацииСтроки(Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьБанковскийСчет(Строка,ВыбранноеЗначение)
	
	ВыдСтроки =  Новый Массив;
	
	Для Каждого текСтр Из Элементы.СписокБанковскихСчетов.ВыделенныеСтроки Цикл
		ВыдСтроки.Добавить(ТекСтр);
	КонецЦикла;
	
	Для Каждого ТекВыд Из ВыдСтроки Цикл
		
		Й = Элементы.СписокБанковскихСчетов.ДанныеСтроки(ТекВыд);
		
		ИзменитьРегистрНаСервере(Й.БанковскиеСчета,Элементы.Список.ТекущиеДанные.Предприятие,ВыбранноеЗначение);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьРегистрНаСервере(БанковскийСчет,Предприятие,Ответственный)
	
	Регистр = РегистрыСведений.Д_ИсточникПП.СоздатьНаборЗаписей();
	Регистр.Отбор.БанковскиеСчета.Установить(БанковскийСчет); 
	Регистр.Прочитать();
	
	Для Каждого стрНабора из Регистр Цикл
		стрНабора.Предприятие = Предприятие;
		стрНабора.ОтветственноеЛицо = Ответственный;
	КонецЦикла;
	
	Регистр.Записать();
	
КонецПроцедуры
