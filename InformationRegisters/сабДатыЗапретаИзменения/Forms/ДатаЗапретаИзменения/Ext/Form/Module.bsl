﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Запрос = новый Запрос;
	//Запрос.УстановитьПараметр("ДоступныеПользователи", ПараметрыСеанса.ДоступныеПользователи);
	Запрос.УстановитьПараметр("ТекДата", ТекущаяДата());
	Запрос.Текст = "ВЫБРАТЬ
	               |	ДатыЗапретаИзмененияСрезПоследних.Пользователь КАК Пользователь,
	               |	МАКСИМУМ(ДатыЗапретаИзмененияСрезПоследних.Комментарий) КАК Комментарий,
	               |	МАКСИМУМ(ВЫБОР
	               |			КОГДА ДатыЗапретаИзмененияСрезПоследних.Пользователь = ЗНАЧЕНИЕ(Перечисление.ВидыНазначенияДатЗапрета.ПоВсемПользователям)
	               |				ТОГДА 0
	               |			ИНАЧЕ 1
	               |		КОНЕЦ) КАК Порядок
	               |ИЗ
	               |	РегистрСведений.сабДатыЗапретаИзменения.СрезПоследних(&ТекДата, ) КАК ДатыЗапретаИзмененияСрезПоследних
				   //|ГДЕ
				   //|	ДатыЗапретаИзмененияСрезПоследних.Пользователь В(&ДоступныеПользователи)
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ДатыЗапретаИзмененияСрезПоследних.Пользователь
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Порядок";
	ТаблицаПользователи = Запрос.Выполнить().Выгрузить();
	ПользователиДатЗапрета.Загрузить(ТаблицаПользователи);
	
	СтрокаПоВсемПользователям = ТаблицаПользователи.Найти(Перечисления.ВидыНазначенияДатЗапрета.ПоВсемПользователям, "Пользователь");
	Если СтрокаПоВсемПользователям = Неопределено Тогда
		СтрокаПоВсемПользователям = ПользователиДатЗапрета.Вставить(0);
		СтрокаПоВсемПользователям.Пользователь = Перечисления.ВидыНазначенияДатЗапрета.ПоВсемПользователям;
	КонецЕсли;
	
	//Пользователи дерево ((
	Дерево = РеквизитФормыВЗначение("ПользователиДерево");   //Дерево = новый ДеревоЗначений;
	Дерево.Строки.Добавить().Пользователь = Перечисления.ВидыНазначенияДатЗапрета.ПоВсемПользователям;
	
	//ВыборкаГруппаИерархия = Справочники.ГруппыПользователей.ВыбратьИерархически();
	//
	//Пока ВыборкаГруппаИерархия.Следующий() Цикл

	//	Если не ВыборкаГруппаИерархия.ПометкаУдаления Тогда
	//		
	//		НайденнаяСтрока = Дерево.Строки.Найти(ВыборкаГруппаИерархия.Родитель, "Пользователь", Истина);
	//		Если НайденнаяСтрока = Неопределено Тогда
	//			НоваяСтрока = Дерево.Строки.Добавить();
	//			НоваяСтрока.Пользователь = ВыборкаГруппаИерархия.Ссылка;
	//		Иначе 
	//			НоваяСтрока = НайденнаяСтрока.Строки.Добавить();
	//			НоваяСтрока.Пользователь = ВыборкаГруппаИерархия.Ссылка;
	//		КонецЕсли;
	//		
	//	КонецЕсли;
	//
	//КонецЦикла;
		
	Запрос.Текст = "ВЫБРАТЬ
	               |	Пользователи.Ссылка КАК Пользователь
	               |ИЗ
	               |	Справочник.Пользователи КАК Пользователи
	               |ГДЕ
	               |	Пользователи.ПометкаУдаления = ЛОЖЬ
	               |	И Пользователи.Недействителен = ЛОЖЬ
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Пользователи.Ссылка.Наименование";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		//Если ЗначениеЗаполнено(Выборка.Группа) Тогда
		//	НайденнаяСтрока = Дерево.Строки.Найти(Выборка.Группа, "Пользователь", Истина);
		//	НайденнаяСтрока.Строки.Добавить().Пользователь = Выборка.Пользователь;
		//Иначе 
			Дерево.Строки.Добавить().Пользователь = Выборка.Пользователь;
		//КонецЕсли;
		
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(Дерево, "ПользователиДерево");
	//Пользователи дерево ))
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ДатыЗапретаИзмененияСрезПоследних.ДатаЗапрета
	               |ИЗ
	               |	РегистрСведений.сабДатыЗапретаИзменения.СрезПоследних(&ТекДата, ) КАК ДатыЗапретаИзмененияСрезПоследних
	               |ГДЕ
	               |	ДатыЗапретаИзмененияСрезПоследних.Объект = ЗНАЧЕНИЕ(Перечисление.ВидыНазначенияДатЗапрета.ПоВсемОбъектам)
	               |	И ДатыЗапретаИзмененияСрезПоследних.Пользователь = ЗНАЧЕНИЕ(Перечисление.ВидыНазначенияДатЗапрета.ПоВсемПользователям)";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ОбщаяДатаЗапрета = Выборка.ДатаЗапрета;
	КонецЕсли;
	
	ЗаполнитьДатыВСпискеПользователей();
	ОбновитьДеревоПользователиПриАктивизацииСтроки(Перечисления.ВидыНазначенияДатЗапрета.ПоВсемПользователям);
	
	ЕстьДоступКИзменению = ПравоДоступа("Изменение", Метаданные.РегистрыСведений.сабДатыЗапретаИзменения);
	ЭтаФорма.ТолькоПросмотр = Не ЕстьДоступКИзменению;
	Элементы.ФормаОтчетПоИзменениямВЗакрытомПериоде.Видимость = ЕстьДоступКИзменению;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//ОбновитьНадписи();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ОбщаяДатаЗапретаПриИзменении(Элемент)
	
	ПоВсемОбъектам      = ПредопределенноеЗначение("Перечисление.ВидыНазначенияДатЗапрета.ПоВсемОбъектам");
	ПоВсемПользователям = ПредопределенноеЗначение("Перечисление.ВидыНазначенияДатЗапрета.ПоВсемПользователям");
	ЗаписатьДатуЗапрета(ПоВсемОбъектам, ПоВсемПользователям, ОбщаяДатаЗапрета);
	
	//Если Элементы.Пользователи.ТекущиеДанные.Пользователь = ПоВсемПользователям Тогда
	Если Элементы.ПользователиДерево.ТекущиеДанные.Пользователь = ПоВсемПользователям Тогда
		ОбновитьДеревоПользователиПриАктивизацииСтроки(ПоВсемПользователям);
		ОбновитьНадписи();
	КонецЕсли;
	
КонецПроцедуры

// *** Таблица Пользователи

&НаКлиенте
Процедура ДобавитьПользователя(Команда)

	ВыбранныйПользователь = Неопределено;


	ОткрытьФорму("Справочник.Пользователи.ФормаВыбора", новый Структура("РежимВыбора", Истина),,,,, Новый ОписаниеОповещения("ДобавитьПользователяЗавершение", ЭтаФорма), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПользователяЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыбранныйПользователь = Результат;
	Если ЗначениеЗаполнено(ВыбранныйПользователь) Тогда
		НоваяСтрока = ПользователиДатЗапрета.Добавить();
		НоваяСтрока.Пользователь = ВыбранныйПользователь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПользователиПередНачаломИзменения(Элемент, Отказ)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Поле          = Элемент.ТекущийЭлемент;
	
	Если ТекущиеДанные.Пользователь = ПредопределенноеЗначение("Перечисление.ВидыНазначенияДатЗапрета.ПоВсемПользователям") Тогда
		Сообщить("Предопределенное значение <Для всех пользователей> не изменяется");
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	
	Если ТекущиеДанные.Пользователь = ПредопределенноеЗначение("Перечисление.ВидыНазначенияДатЗапрета.ПоВсемПользователям") Тогда
		Сообщить("Предопределенное значение <Для всех пользователей> нельзя удалить");
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиПользовательПриИзменении(Элемент)
	//ОбновитьДеревоПользователиПриАктивизацииСтроки(Элементы.Пользователи.ТекущиеДанные.Пользователь);
	ОбновитьДеревоПользователиПриАктивизацииСтроки(Элементы.ПользователиДерево.ТекущиеДанные.Пользователь);
	ОбновитьНадписи();
КонецПроцедуры

&НаКлиенте
Процедура ПользователиКомментарийПриИзменении(Элемент)
	
	//ТекущиеДанные = Элементы.Пользователи.ТекущиеДанные;
	ТекущиеДанные = Элементы.ПользователиДерево.ТекущиеДанные;
	ЗаписатьКомментарий(ТекущиеДанные.Пользователь, ТекущиеДанные.Комментарий);
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиПослеУдаления(Элемент)
	
	//Элементы.Пользователи.Обновить();
	Элементы.ПользователиДерево.Обновить();
	//ОбновитьДеревоПользователиПриАктивизацииСтроки(Элементы.Пользователи.ТекущиеДанные.Пользователь);
	ОбновитьДеревоПользователиПриАктивизацииСтроки(Элементы.ПользователиДерево.ТекущиеДанные.Пользователь);
	ОбновитьНадписи();
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиПользовательОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Тип") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.Пользователи.ТекущиеДанные;
	ТекущиеДанные = Элементы.ПользователиДерево.ТекущиеДанные;
	
	Отказ = Ложь;
	Для Каждого ТекСтрока Из ПользователиДатЗапрета Цикл
		Если ТекСтрока <> ТекущиеДанные и ТекСтрока.Пользователь = ВыбранноеЗначение Тогда
			Сообщить("Пользователи не могут дублироваться!");
			Отказ = Истина;
			//Элементы.Пользователи.ТекущиеДанные.Пользователь = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
			//Элемент.ТекущиеДанные.Пользователь = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Не Отказ Тогда
		ТекущиеДанные.Пользователь = ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиПриАктивизацииСтроки(Элемент)
	
	ОбновитьДеревоПользователиПриАктивизацииСтроки(Элемент.ТекущиеДанные.Пользователь);
	ОбновитьНадписи();
	
КонецПроцедуры

// *** Дерево ДатыЗапрета

&НаКлиенте
Процедура ДобавитьНаправление(Команда)
	
	ВыбранноеНаправление = Неопределено;

	ОткрытьФорму("Справочник.НаправленияДеятельности.ФормаВыбора",,,,,, Новый ОписаниеОповещения("ДобавитьНаправлениеЗавершение", ЭтаФорма), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьНаправлениеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыбранноеНаправление = Результат;
	
	Если ЗначениеЗаполнено(ВыбранноеНаправление) тогда
		ДобавитьНаправлениеПредприятиеНаСервере(ВыбранноеНаправление);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПредприятие(Команда)
	
	ВыбранноеПредприятие = Неопределено;

	
	ОткрытьФорму("Справочник.Предприятия.ФормаВыбора",,,,,, Новый ОписаниеОповещения("ДобавитьПредприятиеЗавершение", ЭтаФорма), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПредприятиеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыбранноеПредприятие = Результат;
	
	Если ЗначениеЗаполнено(ВыбранноеПредприятие) Тогда
		ДобавитьНаправлениеПредприятиеНаСервере(ВыбранноеПредприятие);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДатыЗапретаДеревоДатаЗапретаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДатыЗапретаДерево.ТекущиеДанные;
	//Пользователь  = Элементы.Пользователи.ТекущиеДанные.Пользователь;
	Пользователь  = Элементы.ПользователиДерево.ТекущиеДанные.Пользователь;
	ЗаписатьДатуЗапрета(ТекущиеДанные.Объект, Пользователь, ТекущиеДанные.ДатаЗапрета);
	
	Если ТекущиеДанные.Объект = ПредопределенноеЗначение("Перечисление.ВидыНазначенияДатЗапрета.ПоВсемОбъектам") И
	             Пользователь = ПредопределенноеЗначение("Перечисление.ВидыНазначенияДатЗапрета.ПоВсемПользователям") Тогда
		ОбщаяДатаЗапрета = ТекущиеДанные.ДатаЗапрета;
	КонецЕсли;
	
	ЗаполнитьДатыВСпискеПользователей();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ОбновитьНадписи()
	
	//ТекущиеДанные = Элементы.Пользователи.ТекущиеДанные;
	ТекущиеДанные = Элементы.ПользователиДерево.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено или ТекущиеДанные.Пользователь = ПредопределенноеЗначение("Перечисление.ВидыНазначенияДатЗапрета.ПоВсемПользователям") Тогда
		Элементы.ДекорацияПользователь.Заголовок = "Даты запрета по всем пользователям";
	Иначе 
		Элементы.ДекорацияПользователь.Заголовок = "Даты запрета по пользователю " + ТекущиеДанные.Пользователь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьКомментарий(Пользователь, Комментарий)
	
	НаборЗаписей = РегистрыСведений.сабДатыЗапретаИзменения.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Пользователь.Установить(Пользователь);
	НаборЗаписей.Прочитать();
	Для Каждого ТекЗапись Из НаборЗаписей Цикл
		ТекЗапись.Комментарий = Комментарий;
	КонецЦикла;
	НаборЗаписей.Записать();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьДатуЗапрета(Объект, Пользователь, ДатаЗапрета)
	
	МенеджерЗаписи = РегистрыСведений.сабДатыЗапретаИзменения.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Объект       = Объект;
	МенеджерЗаписи.Пользователь = Пользователь;
	МенеджерЗаписи.Период       = НачалоДня(ТекущаяДата());
	МенеджерЗаписи.ДатаЗапрета  = ДатаЗапрета;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДеревоПользователиПриАктивизацииСтроки(Пользователь)
	
	Запрос = новый Запрос;
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.УстановитьПараметр("ДоступныеПредприятия", ПараметрыСеанса.ДоступныеПредприятия);
	Запрос.УстановитьПараметр("ТекДата", ТекущаяДата());
	Запрос.Текст = "ВЫБРАТЬ
	               |	ДатыЗапретаИзмененияСрезПоследних.Объект,
	               |	ДатыЗапретаИзмененияСрезПоследних.ДатаЗапрета,
	               |	ДатыЗапретаИзмененияСрезПоследних.Комментарий,
	               |	ВЫБОР
	               |		КОГДА ДатыЗапретаИзмененияСрезПоследних.Объект = ЗНАЧЕНИЕ(Перечисление.ВидыНазначенияДатЗапрета.ПоВсемОбъектам)
	               |			ТОГДА 1
	               |		КОГДА ДатыЗапретаИзмененияСрезПоследних.Объект ССЫЛКА Справочник.НаправленияДеятельности
	               |			ТОГДА 2
	               |		КОГДА ДатыЗапретаИзмененияСрезПоследних.Объект ССЫЛКА Справочник.Предприятия
	               |			ТОГДА 3
	               |	КОНЕЦ КАК Порядок
	               |ИЗ
	               |	РегистрСведений.сабДатыЗапретаИзменения.СрезПоследних(&ТекДата, ) КАК ДатыЗапретаИзмененияСрезПоследних
	               |ГДЕ
	               |	ДатыЗапретаИзмененияСрезПоследних.Пользователь = &Пользователь
	               |	И (НЕ ДатыЗапретаИзмененияСрезПоследних.Объект ССЫЛКА Справочник.Предприятия
	               |			ИЛИ ДатыЗапретаИзмененияСрезПоследних.Объект В (&ДоступныеПредприятия))
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Порядок";
	Выборка = Запрос.Выполнить().Выбрать();
				   
	Дерево = РеквизитФормыВЗначение("ДатыЗапретаДерево"); //Дерево = новый ДеревоЗначений;
	Дерево.Строки.Очистить();
	
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.ДатаЗапрета) Тогда
			ДанныеСтруктура = новый Структура("Объект, ДатаЗапрета, Комментарий");
			ЗаполнитьЗначенияСвойств(ДанныеСтруктура, Выборка);
			ДобавитьСтрокуВДерево(Дерево, ДанныеСтруктура);
		КонецЕсли;
	КонецЦикла;	
	
	Если Дерево.Строки.Найти(Перечисления.ВидыНазначенияДатЗапрета.ПоВсемОбъектам) = Неопределено Тогда
		НоваяСтрокаДерева = Дерево.Строки.Вставить(0);
		НоваяСтрокаДерева.Объект = Перечисления.ВидыНазначенияДатЗапрета.ПоВсемОбъектам;
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(Дерево, "ДатыЗапретаДерево");
		
КонецПроцедуры

&НаСервере
Процедура ДобавитьНаправлениеПредприятиеНаСервере(Объект)
	
	Дерево = РеквизитФормыВЗначение("ДатыЗапретаДерево");
	ДобавитьСтрокуВДерево(Дерево, новый Структура("Объект", Объект));
	ЗначениеВРеквизитФормы(Дерево, "ДатыЗапретаДерево");
		
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДобавитьСтрокуВДерево(Дерево, ДанныеСтруктура)
	
	Объект = ДанныеСтруктура.Объект;    //Дерево = новый ДеревоЗначений;
	
	Если ТипЗнч(Объект) <> Тип("СправочникСсылка.Предприятия") Тогда
		
		Если Дерево.Строки.Найти(Объект, "Объект", Ложь) = Неопределено Тогда
			НоваяСтрокаДерева = Дерево.Строки.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаДерева, ДанныеСтруктура);
		Иначе
			Сообщить("Предприятие " + Объект + " уже добавлено");
		КонецЕсли;
		
	Иначе       //Вставляем предприятие. Если направления предприятия нет, то добавляем и его 
		
		Если ЗначениеЗаполнено(Объект.Родитель) Тогда
			НайденнаяСтрокаНаправление = Дерево.Строки.Найти(Объект.Родитель, "Объект", Ложь);
			
			Если НайденнаяСтрокаНаправление = Неопределено Тогда
				НайденнаяСтрокаНаправление = Дерево.Строки.Добавить();
				НайденнаяСтрокаНаправление.Объект = Объект.Родитель;
			КонецЕсли;
			
			Если НайденнаяСтрокаНаправление.Строки.Найти(Объект, "Объект", Ложь) = Неопределено Тогда
				НоваяСтрокаДерева = НайденнаяСтрокаНаправление.Строки.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрокаДерева, ДанныеСтруктура);
			Иначе
				Сообщить("Предприятие " + Объект + " уже добавлено");
			КонецЕсли;
			
		Иначе
			
			Если Дерево.Строки.Найти(Объект, "Объект", Ложь) = Неопределено Тогда
				НоваяСтрокаДерева = Дерево.Строки.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрокаДерева, ДанныеСтруктура);
			Иначе
				Сообщить("Предприятие " + Объект + " уже добавлено");
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДобавитьСтрокуВДеревоПользователей(Дерево, Пользователь, Родитель)
	
	Дерево = новый ДеревоЗначений;
	 
	//найти родителя в дереве.  
	НайденнаяСтрока = Дерево.Строки.Найти(Родитель, "Пользователь", Истина);
	Если НайденнаяСтрока = Неопределено Тогда
		НоваяСтрока = Дерево.Строки.Добавить();
	Иначе 
		НоваяСтрока = НайденнаяСтрока.Строки.Добавить();
	КонецЕсли;
	 
	//Дерево.
	
КонецПроцедуры	

&НаКлиенте
Процедура ОтчетПоИзменениямВЗакрытомПериоде(Команда)
	
	ОткрытьФорму("Отчет.ОтчетПоИзменениямВЗакрытомПериоде.ФормаОбъекта");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДатыВСпискеПользователей()
	
	Дерево = РеквизитФормыВЗначение("ПользователиДерево");   //Дерево = новый ДеревоЗначений;
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ДатыЗапретаИзмененияСрезПоследних.Пользователь,
	               |	ДатыЗапретаИзмененияСрезПоследних.ДатаЗапрета
	               |ИЗ
	               |	РегистрСведений.сабДатыЗапретаИзменения.СрезПоследних КАК ДатыЗапретаИзмененияСрезПоследних";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НайденнаяСтрока = Дерево.Строки.Найти(Выборка.Пользователь, "Пользователь", Истина);
		Если НайденнаяСтрока <> Неопределено Тогда
			НайденнаяСтрока.ДатаЗапрета = Выборка.ДатаЗапрета;
		КонецЕсли;
	КонецЦикла;
	ЗначениеВРеквизитФормы(Дерево, "ПользователиДерево");
	
КонецПроцедуры

