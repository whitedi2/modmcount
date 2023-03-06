﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	БюджетныйНаСервере.ДействияПриСозданииФормыДокумента(ЭтаФорма);
	
	Если Параметры.Свойство("ВидЗаказа") Тогда
		ЭлементыДляУдаления = Новый Массив;
		
		ЭлементыОтбора = Список.Отбор.Элементы;
		ПолеКомпоновки = Новый ПолеКомпоновкиДанных("ВидОперации");
		Для Каждого ЭлементОтбора Из ЭлементыОтбора Цикл
			Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных")
				И ЭлементОтбора.ЛевоеЗначение = ПолеКомпоновки Тогда
				ЭлементыДляУдаления.Добавить(ЭлементОтбора);
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого ЭлементОтбораДляУдаления Из ЭлементыДляУдаления Цикл
			ЭлементыОтбора.Удалить(ЭлементОтбораДляУдаления);
		КонецЦикла;	
		
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ВидОперации");	
		ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.ВСписке;
		ЭлементОтбора.Использование  = Истина;
		Если Параметры.ВидЗаказа = "ЗаказНаПеремещение" Тогда
			СписокВидовОпераций = Новый Массив;
			СписокВидовОпераций.Добавить(Перечисления.ВидыЗаказов.ВнутреннееПеремещение);
			СписокВидовОпераций.Добавить(Перечисления.ВидыЗаказов.ПеремещениеМеждуСкладами);
			ЭлементОтбора.ПравоеЗначение = СписокВидовОпераций;
			Если НЕ Элементы.Найти("ФормаДокументУЧ_ВозвратТоваровПоставщикуСоздатьНаОсновании") = Неопределено Тогда
				Элементы.ФормаДокументУЧ_ВозвратТоваровПоставщикуСоздатьНаОсновании.Видимость = Ложь;
			КонецЕсли;
			Если НЕ Элементы.Найти("ФормаДокументУЧ_ПоступлениеТоваровСоздатьНаОсновании") = Неопределено Тогда
				Элементы.ФормаДокументУЧ_ПоступлениеТоваровСоздатьНаОсновании.Видимость = Ложь;
			КонецЕсли;
		ИначеЕсли Параметры.ВидЗаказа = "ЗаказПоставщику" Тогда
			ЭлементОтбора.ПравоеЗначение = Перечисления.ВидыЗаказов.ЗакупкаТоваров;
			Если НЕ Элементы.Найти("ФормаДокументУЧ_ВозвратТоваровПоставщикуСоздатьНаОсновании") = Неопределено Тогда
				Элементы.ФормаДокументУЧ_ВозвратТоваровПоставщикуСоздатьНаОсновании.Видимость = Ложь;
			КонецЕсли;
			Если НЕ Элементы.Найти("ФормаДокументУЧ_ПеремещениеТоваровСоздатьНаОсновании") = Неопределено Тогда
				Элементы.ФормаДокументУЧ_ПеремещениеТоваровСоздатьНаОсновании.Видимость = Ложь;
			КонецЕсли;
			Если НЕ Элементы.Найти("ФормаДокументУЧ_РеализацияСоздатьНаОсновании") = Неопределено Тогда
				Элементы.ФормаДокументУЧ_РеализацияСоздатьНаОсновании.Видимость = Истина;
			КонецЕсли;
		ИначеЕсли Параметры.ВидЗаказа = "ЗаказНаВозврат" Тогда
			ЭлементОтбора.ПравоеЗначение = Перечисления.ВидыЗаказов.ВозвратБрака;
			Если НЕ Элементы.Найти("ФормаДокументУЧ_ПоступлениеТоваровСоздатьНаОсновании") = Неопределено Тогда
				Элементы.ФормаДокументУЧ_ПоступлениеТоваровСоздатьНаОсновании.Видимость = Ложь;
			КонецЕсли;
			Если НЕ Элементы.Найти("ФормаДокументУЧ_ПеремещениеТоваровСоздатьНаОсновании") = Неопределено Тогда
				Элементы.ФормаДокументУЧ_ПеремещениеТоваровСоздатьНаОсновании.Видимость = Ложь;
			КонецЕсли;
			Если НЕ Элементы.Найти("ФормаДокументУЧ_РеализацияСоздатьНаОсновании") = Неопределено Тогда
				Элементы.ФормаДокументУЧ_РеализацияСоздатьНаОсновании.Видимость = Ложь;
			КонецЕсли;
		КонецЕсли;	
	КонецЕсли;
	
	Если РольДоступна("сабМенеджерПоЗакупкам") Тогда
		ТолькоМои = Истина;
		ТолькоОткрытые = Истина;
	ИначеЕсли РольДоступна("сабКладовщик") Тогда
		ТолькоМои = Ложь;
		ТолькоОткрытые = Истина;
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("ТолькоМои", ТолькоМои);
	Список.Параметры.УстановитьЗначениеПараметра("ТолькоОткрытые", ТолькоОткрытые);
	Список.Параметры.УстановитьЗначениеПараметра("Пользователи", БПСервер.ПолучитьМассивПользователей());
	
	Если Параметры.Свойство("Статус") Тогда
		Список.Параметры.УстановитьЗначениеПараметра("Статус", Параметры.Статус); 
	КонецЕсли; 
	
	Если Параметры.Свойство("УжеВыбрано") Тогда
		Список.Параметры.УстановитьЗначениеПараметра("УжеВыбрано", Параметры.УжеВыбрано); 
		Список.Параметры.УстановитьЗначениеПараметра("ВсеЗаказы", Ложь); 
	Иначе
		Список.Параметры.УстановитьЗначениеПараметра("УжеВыбрано", Новый Массив); 
		Список.Параметры.УстановитьЗначениеПараметра("ВсеЗаказы", Истина); 
	КонецЕсли;
	
	//Элементы.ФормаЗагрузитьЗаказыИзExcel.Видимость = (ПравоДоступа("Использование", Метаданные.Обработки.ЗагрузкаКарточкиExcel));		
	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьЗаказыИзExcel(Команда)
	ОткрытьФорму("Обработка.ЗагрузкаЗаказовПоставщикуИзExcel.Форма.Форма");
КонецПроцедуры

&НаКлиенте
Процедура СтатусСогласовано(Команда)
	ВыдСтроки = Элементы.Список.ВыделенныеСтроки;
	СтатусСогласованоНаСервере(ВыдСтроки, Команда.Имя);
	Элементы.Список.Обновить();
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СтатусСогласованоНаСервере(Заявки, ИмяКоманды)
	
	Если ИмяКоманды = "СтатусСогласовано" Тогда
		Точка = Перечисления.СтатусыЗаказовПоставщикам.Подтвержден;
	ИначеЕсли ИмяКоманды = "СтатусНеСогласовано" Тогда
		Точка = Перечисления.СтатусыЗаказовПоставщикам.Создан;
	ИначеЕсли ИмяКоманды = "СтатусКОплате" Тогда
		Точка = Перечисления.СтатусыЗаказовПоставщикам.КПоступлению;
	ИначеЕсли ИмяКоманды = "СтатусОтменено" Тогда
		Точка = Перечисления.СтатусыЗаказовПоставщикам.Отменен;
	Иначе
		Точка = Перечисления.СтатусыЗаказовПоставщикам.Создан;
	КонецЕсли;
	
	Для каждого ТекЗаявка Из Заявки Цикл
		Об = ТекЗаявка.ПолучитьОбъект();
		Об.Статус = Точка;
		Если Об.Проведен Тогда
			Об.Записать(РежимЗаписиДокумента.Проведение);
		Иначе	
			Об.Записать();
		КонецЕсли;
	КонецЦикла; 
		
КонецПроцедуры

&НаКлиенте
Процедура ТолькоМоиПриИзменении(Элемент)
	Список.Параметры.УстановитьЗначениеПараметра("ТолькоМои", ТолькоМои);
	Список.Параметры.УстановитьЗначениеПараметра("ТолькоОткрытые", ТолькоОткрытые);
КонецПроцедуры

&НаКлиенте
Процедура ТолькоОткрытыеПриИзменении(Элемент)
	Список.Параметры.УстановитьЗначениеПараметра("ТолькоМои", ТолькоМои);
	Список.Параметры.УстановитьЗначениеПараметра("ТолькоОткрытые", ТолькоОткрытые);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОповеститьРегистрОбработанных" Тогда
		Элементы.Список.Обновить();;
	КонецЕсли;

КонецПроцедуры


