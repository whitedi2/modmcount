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
		ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование  = Истина;
		Если Параметры.ВидЗаказа = "ЗаказНаПеремещение" Тогда
			ЭлементОтбора.ПравоеЗначение = Перечисления.ВидыЗаказов.ВнутреннееПеремещение;
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
	
	//Элементы.ФормаЗагрузитьЗаказыИзExcel.Видимость = (ПравоДоступа("Использование", Метаданные.Обработки.ЗагрузкаКарточкиExcel));		
	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	
	Если РольДоступна("сабМенеджерПоПродажам") Тогда
		ТолькоМои = Истина;
		Элементы.ТолькоМои.Доступность = РольДоступна("сабРуководительПоПродажам");
		ТолькоОткрытые = Истина;
	КонецЕсли;
	Список.Параметры.УстановитьЗначениеПараметра("ТолькоМои", ТолькоМои);
	Список.Параметры.УстановитьЗначениеПараметра("ТолькоОткрытые", ТолькоОткрытые);
	Список.Параметры.УстановитьЗначениеПараметра("Пользователи", БПСервер.ПолучитьМассивПользователей());
	
	ВидимостьПредприятия = БюджетныйНаСервере.ПолучитьПредприятия().Количество() > 1;
	
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
		Точка = Перечисления.СтатусыЗаказовКлиентов.КОтгрузке;
	ИначеЕсли ИмяКоманды = "СтатусНеСогласовано" Тогда
		Точка = Перечисления.СтатусыЗаказовКлиентов.Новый;
	ИначеЕсли ИмяКоманды = "СтатусКОплате" Тогда
		Точка = Перечисления.СтатусыЗаказовКлиентов.Отгружен;
	ИначеЕсли ИмяКоманды = "СтатусОтменено" Тогда
		Точка = Перечисления.СтатусыЗаказовКлиентов.Отменен;
	Иначе
		Точка = Перечисления.СтатусыЗаказовКлиентов.Новый;
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
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Не Элементы.Список.РежимВыбора Тогда
		Если Поле.Имя = "Статус" Тогда
			СтандартнаяОбработка = Ложь;
			СписокЗначений = Новый СписокЗначений;
			СписокЗначений.ЗагрузитьЗначения(ПолучитьСписокСтатусовЗаказа());
			ТекЗнач = Неопределено;

			ПоказатьВыборИзСписка(Новый ОписаниеОповещения("СписокВыборЗавершение", ЭтаФорма), СписокЗначений, , СписокЗначений.НайтиПоЗначению(Элементы.Список.ТекущиеДанные.Статус));
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	ТекЗнач = ВыбранныйЭлемент;
	Если Не ТекЗнач = Неопределено Тогда
		ЗаписатьНовыйСтатусЗаказа(Элементы.Список.ТекущаяСтрока, ТекЗнач.Значение);
		Элементы.Список.Обновить();
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСписокСтатусовЗаказа()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	СтатусыЗаказовКлиентов.Ссылка
	|ИЗ
	|	Перечисление.СтатусыЗаказовКлиентов КАК СтатусыЗаказовКлиентов";
	
	Результат = Запрос.Выполнить();
	Возврат Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции // ()

&НаСервереБезКонтекста
Процедура ЗаписатьНовыйСтатусЗаказа(Документ, НовыйСтатусЗаказа)
	ТекБанкОб = Документ.ПолучитьОбъект();
	ТекБанкОб.Статус = НовыйСтатусЗаказа;
	ТекБанкОб.Записать();
КонецПроцедуры



