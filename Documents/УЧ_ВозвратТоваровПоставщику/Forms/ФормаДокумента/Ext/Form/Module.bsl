﻿&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
	//	МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
	//	МодульУправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	//КонецЕсли;
	
	//++саб
	сабПриЧтенииНаСервере(ТекущийОбъект);
	//--саб
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
	//	МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
	//	МодульУправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, Новый Структура("ИмяЭлементаДляРазмещения", "СтраницаДополнительныеРеквизиты") );
	//КонецЕсли;
	
	//++саб
	сабПриСозданииНаСервере(Отказ, СтандартнаяОбработка);
	//--саб
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
	//	МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
	//	МодульУправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	//КонецЕсли;
	
	//++саб
	сабПриОткрытии(Отказ);
	//--саб
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	//Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
	//	МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
	//	Если МодульУправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
	//		ОбновитьЭлементыДополнительныхРеквизитов();
	//		МодульУправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	//	КонецЕсли;
	//КонецЕсли;
	
	//++саб
	сабОбработкаОповещения(ИмяСобытия, Параметр, Источник);
	//--саб
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
	//	МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
	//	МодульУправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	//КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
	//	МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
	//	МодульУправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	//КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
	
	//Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
	//	МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
	//	МодульУправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтотОбъект, Объект.Ссылка);
	//КонецЕсли;
	
КонецПроцедуры


// СтандартныеПодсистемы.КонтактнаяИнформация

// Поддержка дополнительных реквизитов.

&НаСервере
Процедура СвойстваВыполнитьОтложеннуюИнициализацию()
	
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
	//	МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
	//	МодульУправлениеСвойствами.ЗаполнитьДополнительныеРеквизитыВФорме(ЭтотОбъект);
	//КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	
	//Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
	//	МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
	//	МодульУправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
	//КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	
	//Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
	//	МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
	//	МодульУправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
	//КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
	//	МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
	//	МодульУправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
	//КонецЕсли;
	
КонецПроцедуры




// Конец СтандартныеПодсистемы.КонтактнаяИнформация

&НаКлиенте
Процедура сабПриОткрытии(Отказ)
	
	//-lud 19/10/22 Вся проверка вынесена в модуль объекта, в процедуру Обработка заполнения
    //Отказ = сабОперОбщегоНазначенияНаКлиенте.ПроверкаСозданияНаОснованииНаКлиенте(Объект);
	//Если Отказ Тогда
	//	Возврат;	
	//КонецЕсли; 
	
	Если СтрНайти(Объект.Комментарий, "##НеверныйВидОперации") Тогда
		Предупреждение("Невозможно создать возврат поставщику. Неверный вид операции: <" + Сред(Объект.Комментарий, 22) + ">!");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.СчетКонтрагента) Тогда
		СоответствиеСчетаИФлага();
		Прочитать();
	КонецЕсли;
	
	СчетПриИзменении(Неопределено);
	
	ФлагВалютыПриИзменении("");
	
	Если Объект.Услуги.Количество() > 0 И Объект.Товары.Количество() = 0 Тогда
		Элементы.Группа1.ТекущаяСтраница = Элементы.Группа6;
	КонецЕсли;	
	
	Элементы.ИсправленныеСФ.Видимость = Объект.ИсправлениеСФ;	
	
КонецПроцедуры
  
&НаКлиенте
Процедура ТабличнаяЧастьКоличествоПриИзменении(Элемент)

	РассчитатьСумму();
	Если РежимСканирования Тогда
		ПодобратьНоменклатуруПоШК(Неопределено);
		Элементы.Товары.ЗакончитьРедактированиеСтроки(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьЦенаПриИзменении(Элемент)
	РассчитатьСумму();
КонецПроцедуры
&НаКлиенте
Процедура ТабличнаяЧастьДоставкаПриИзменении(Элемент)
	Если Элементы.Товары.ТекущиеДанные.Доставка Тогда
		Элементы.Товары.ТекущиеДанные.СуммаДоставки = Элементы.Товары.ТекущиеДанные.Количество * Элементы.Товары.ТекущиеДанные.Доставка;
	КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьСуммаПриИзменении(Элемент)
	ТекКоличество = Элементы.Товары.ТекущиеДанные.Количество;
	Элементы.Товары.ТекущиеДанные.Цена = ?(ТекКоличество <> 0, Элементы.Товары.ТекущиеДанные.Сумма / ТекКоличество, 0);
КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьСуммаДоставкиПриИзменении(Элемент)
	ТекКоличество = Элементы.Товары.ТекущиеДанные.Количество;
	Элементы.Товары.ТекущиеДанные.Доставка = ?(ТекКоличество <> 0, Элементы.Товары.ТекущиеДанные.СуммаДоставки / ТекКоличество, 0);
КонецПроцедуры

&НаКлиенте
Процедура ПредприятиеПриИзменении(Элемент)
	ПредприятиеПриИзмененииНаСервере();
	//УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("сабУчетПоПодразделениям", Объект.Предприятие));
	
	//Объект.РегистрироватьЦенуПоступления = сабОбщегоНазначения.ПолучитьПараметрыУчетнойПолитики(Объект.Предприятие, ?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДата())).РегистрироватьЦенуПриПоступлении;
	
КонецПроцедуры

&НаСервере
Процедура ПредприятиеПриИзмененииНаСервере()
	сабОбщегоНазначенияКлиентСервер.СкрытьПодразделения(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ФлагВалютыПриИзменении(Элемент)
	Элементы.ГруппаВалюты.Видимость = Объект.ФлагВалюты;
КонецПроцедуры

&НаКлиенте
Процедура ВалютаПриИзменении(Элемент)
	Объект.Курс = БюджетныйНаСервере.ТекущийКурс(Объект.Валюта,Объект.Дата,Объект.Предприятие);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСчета60()
	
	Счета60 = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Учетный.Ссылка
	|ИЗ
	|	ПланСчетов.Учетный КАК Учетный
	|ГДЕ
	|	Учетный.Родитель = &Счет60";
	
    Запрос.УстановитьПараметр("Счет60", ПланыСчетов.Учетный.Счет60());
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Счета60.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	Возврат Счета60;
	
КонецФункции

&НаКлиенте
Процедура СчетПриИзменении(Элемент)
	
	ДанныеСчета = УправленческийУчетПовтИсп.ПолучитьСвойстваСчета(Объект.СчетКонтрагента, Объект.Предприятие);
	
	Наименование1 = ДанныеСчета["ВидСубконто1Наименование"];
	Наименование2 = ДанныеСчета["ВидСубконто2Наименование"];
	Наименование3 = ДанныеСчета["ВидСубконто3Наименование"];
	
	Элементы.Контрагент.Заголовок = Наименование1;
	Элементы.Договор.Заголовок = Наименование2;
	
	Если Наименование1 = "" Тогда
		Элементы.Контрагент.Доступность = Ложь;
	Иначе
		Элементы.Контрагент.Доступность = Истина;
	КонецЕсли;
	
	Если Наименование2 = "" Тогда
		Элементы.Договор.Доступность = Ложь;
	Иначе
		Элементы.Договор.Доступность = Истина;
	КонецЕсли;
	
	Если Объект.СчетКонтрагента = УЧ_Сервер.СчетПоКоду("79.02") Тогда
		Элементы.ПодразделениеВн.Видимость = Истина;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура СоответствиеСчетаИФлага()
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ТекущийДокумент = Объект.Ссылка.ПолучитьОбъект();
		
		//Если Объект.Флаг60_79 = 0 Тогда
			ТекущийДокумент.СчетКонтрагента = ПланыСчетов.Учетный.Счет6001();
		//ИначеЕсли Объект.Флаг60_79 = 1 Тогда
		//	ТекущийДокумент.СчетКонтрагента = ПланыСчетов.Учетный.Счет7902();
		//ИначеЕсли Объект.Флаг60_79 = 2 Тогда
		//	ТекущийДокумент.СчетКонтрагента = ПланыСчетов.Учетный.УсловеноВнутренниеВзаиморасчеты
		//КонецЕсли;	
		
		ТекущийДокумент.Записать(РежимЗаписиДокумента.Запись);
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьСтатьяНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекФорма = ПолучитьФорму("Справочник.СтатьиЗатрат.Форма.ФормаВыбораБезГрупп", , Элемент);
	
	НовыйОтбор = ТекФорма.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Наименование");
	НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Содержит;
	НовыйОтбор.ПравоеЗначение = "Транспортные";
	
	ТекФорма.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура РеализацияВидДоставкиПриИзменении(Элемент)
	
	Если Элементы.Товары.ТекущиеДанные.ВидДоставки = "Авто" Тогда
		Элементы.Товары.ТекущиеДанные.Статья = ПредопределенноеЗначение("Справочник.СтатьиЗатрат.ТранспортныеАвто");
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура сабПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	БюджетныйНаСервере.ДействияПриСозданииФормыДокумента(ЭтаФорма);
	ЗаполнитьСчетаПокупателя();
	
	//Если ЗначениеЗаполнено(Объект.Подразделение) Тогда
	//	Объект.Склад = Объект.Подразделение.Склад;			
	//КонецЕсли; 
	
	Если Не ЗначениеЗаполнено(Объект.ДокОснование) ИЛИ ТипЗнч(Объект.ДокОснование) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		УстановитьСвязьПоВиду();
	КонецЕсли; 
	
	//Если Не БюджетныйНаСервере.РольАдминаДоступнаСервер() И Не сабОбщегоНазначения.ПолучитьЗначениеСвойства(БюджетныйНаСервере.ПолучитьПользователя(), "Возможность менять цену в заказах (Пользователь)") = Истина Тогда
	//	Элементы.ТоварыВидЦеныПоставщика.ТолькоПросмотр = Истина;
	//	Элементы.ТабличнаяЧастьЦена.ТолькоПросмотр = Истина;
	//	Элементы.ТабличнаяЧастьСумма.ТолькоПросмотр = Истина;
	//	Элементы.ТабличнаяЧастьСтавкаНДС.ТолькоПросмотр = Истина;
	//	Элементы.ТабличнаяЧастьСуммаНДС.ТолькоПросмотр = Истина;
	//	Элементы.ТоварыОбновитьЦену.Видимость = Ложь;
	//КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Склад = сабОперОбщегоНазначения.ПолучитьСкладПоДопСвойству(ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Склад возврата (Склады)", Истина), Объект.Предприятие);	
		Если ЗначениеЗаполнено(Объект.Склад) И НЕ рольдоступна("сабУчетчик") Тогда
			Элементы.Склад.Доступность = Ложь;
		КонецЕсли;
		Объект.СуммаВключаетНДС = Истина;
		Объект.ЦенаВключаетНДС	= Истина;
		Объект.УчитыватьНДС		= Истина;
	Иначе
		Если Объект.Склад = сабОперОбщегоНазначения.ПолучитьСкладПоДопСвойству(ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Склад возврата (Склады)", Истина), Объект.Предприятие)  И НЕ рольдоступна("сабУчетчик") Тогда
			Элементы.Склад.Доступность = Ложь;
		КонецЕсли; 
	КонецЕсли;
	
	//временно, позже изменить тип реквизита
	Элементы.Контрагент.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
	Элементы.Договор.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ДоговорыКонтрагентов");
	
	ИспользоватьСерии = Справочники.СерииНоменклатуры.СерииНоменклатурыИспользуются(); 
	
	Для Каждого СтрокаТЧ Из Объект.Товары Цикл
		НайденныеСерии = Объект.СерииНоменклатуры.НайтиСтроки(Новый Структура("Номенклатура, НомерСтрокиРеализации", СтрокаТЧ.Номенклатура, СтрокаТЧ.НомерСтроки));
		Если НайденныеСерии.Количество() > 1 Тогда
			СтрокаТЧ.НесколькоСерий = Истина;
			СтрокаТЧ.СерияНоменклатуры = Неопределено;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСвязьПоВиду()
	Массив = Новый Массив;
	Массив.Добавить(Тип("ДокументСсылка.ЗаказПоставщику"));
	ОписаниеТиповЧ = Новый ОписаниеТипов(Массив);
	Элементы.ДокОснование.ОграничениеТипа = ОписаниеТиповЧ;
	
	НоваяСвязь = Новый ПараметрВыбора("Отбор.ВидОперации", Перечисления.ВидыЗаказов.ВозвратБрака);
	НоваяСвязь2 = Новый ПараметрВыбора("Отбор.Подразделение", Объект.Подразделение);
	НовыйМассив = Новый Массив();
	НовыйМассив.Добавить(НоваяСвязь);
	НовыйМассив.Добавить(НоваяСвязь2);
	НовыеСвязи = Новый ФиксированныйМассив(НовыйМассив);
	Элементы.ДокОснование.ПараметрыВыбора = НовыеСвязи;
КонецПроцедуры

&НаСервере
Функция ЗаполнитьСчетаПокупателя()
	
	МассивСчетовРеализация = Новый Массив;
	МассивСчетовРеализация.Добавить(ПланыСчетов.Учетный.Счет60());
	МассивСчетовРеализация.Добавить(ПланыСчетов.Учетный.Счет7902());
	
	МассивГруппСчетовРеализация = Новый Массив;
	МассивГруппСчетовРеализация.Добавить(ПланыСчетов.Учетный.Счет60());
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Учетный.Ссылка
	|ИЗ
	|	ПланСчетов.Учетный КАК Учетный
	|ГДЕ
	|	Учетный.Ссылка В ИЕРАРХИИ (&СписокСчетов) И НЕ Учетный.Ссылка В (&СписокГруппСчетов)";
	
	Запрос.УстановитьПараметр("СписокСчетов", МассивСчетовРеализация);
	Запрос.УстановитьПараметр("СписокГруппСчетов", МассивГруппСчетовРеализация);
	КоректныйМассивСчетов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Элементы.Счет.СписокВыбора.ЗагрузитьЗначения(КоректныйМассивСчетов);
	Для каждого ТекСчет Из Элементы.Счет.СписокВыбора Цикл
		Попытка
			ТекСчет.Представление = Строка(ТекСчет.Значение) + " " + ТекСчет.Значение.Номенклатура;	
		Исключение
		КонецПопытки;
	КонецЦикла;
	
КонецФункции


&НаКлиенте
Процедура СоздатьСоответствие(Команда)
	
	ТекЭлемент = Элементы.Услуги.ТекущиеДанные[СтрЗаменить(Элементы.Услуги.ТекущийЭлемент.Имя, "Услуги", "")];
	ФормаСоответствия = ПолучитьФорму("Справочник.СоответствиеОбъектов.Форма.ФормаЭлемента");
	ФормаСоответствия.Объект.Значение77 = ТекЭлемент;
	ФормаСоответствия.Объект.Предприятие = Объект.Предприятие;
	ФормаСоответствия.Объект.ТипДокумента = "Поступление товаров и услуг";
	ФормаСоответствия.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура сабОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьФормуУч_Операция" И Параметр = Объект.Ссылка Тогда
		ЭтаФорма.Прочитать();
		ОбновитьОтображениеДанных();
	ИначеЕсли ИмяСобытия = "Запись_Файл" Тогда
		Если Параметр.Свойство("ФормаВладелецУИД") И Параметр.ФормаВладелецУИД = ЭтаФорма.УникальныйИдентификатор Тогда
			сабОбщегоНазначения.ПрикрепитьФайлКДокументу(Параметр); 
		КонецЕсли
	КонецЕсли;	
		
КонецПроцедуры

&НаСервере
Процедура сабПриЧтенииНаСервере(ТекущийОбъект)
	сабОбщегоНазначения.ОтобразитьСостояниеДокумента(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	сабОбщегоНазначения.ОтобразитьСостояниеДокумента(ЭтаФорма, ТекущийОбъект);
КонецПроцедуры

&НаКлиенте
Процедура УслугиКоличествоПриИзменении(Элемент)
	
	РассчитатьСумму();
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСумму()
	
	ТекДанные = Элементы.Товары.ТекущиеДанные;
	
	Если Не ТекДанные = Неопределено Тогда
		ТекДанные.Сумма = ТекДанные.Количество * ТекДанные.Цена;
		ОбработкаТабличныхЧастейКлиентСервер.ПриИзмененииКоличествоЦена(ЭтаФорма, "Товары");
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура УслугиЦенаПриИзменении(Элемент)
	
	РассчитатьСумму();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсправлениеСФПриИзменении(Элемент)
	
	Элементы.ИсправленныеСФ.Видимость = Объект.ИсправлениеСФ;	
	
КонецПроцедуры

&НаКлиенте
Процедура ИсправленныеСФПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		МаксТекущийНомер = 0;
		Для Каждого СтрокаИсправлений Из Объект.ИсправленныеСФ Цикл
			МаксТекущийНомер = Макс(СтрокаИсправлений.НомерИсправления, МаксТекущийНомер);
		КонецЦикла;	
		Элемент.ТекущиеДанные.ДатаИсправления = ТекущаяДата();
		Элемент.ТекущиеДанные.НомерИсправления = МаксТекущийНомер + 1;
	КонецЕсли;	
	
КонецПроцедуры


&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	ПодразделениеПриИзмененииСервер();	
КонецПроцедуры

&НаСервере
Процедура ПодразделениеПриИзмененииСервер()
	
	Если ЗначениеЗаполнено(Объект.Подразделение) Тогда
		РеквизитыПодразделения = БюджетныйНаСервере.ВернутьРеквизиты(Объект.Подразделение, "Склад, Организация");
		Объект.Склад = сабОперОбщегоНазначения.ПолучитьСкладПоДопСвойству(ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Склад возврата (Склады)", Истина), Объект.Предприятие);	
		Если ЗначениеЗаполнено(Объект.Склад) Тогда
			Элементы.Склад.Доступность = Ложь;
		Иначе
			Объект.Склад = РеквизитыПодразделения.Склад;
		КонецЕсли;
		Объект.Организация = РеквизитыПодразделения.Организация;
	КонецЕсли; 
	КонтрагентПриИзмененииСервер();
	
	
КонецПроцедуры


#Область ПоискПоШК

&НаКлиенте
Процедура ПодобратьНоменклатуруПоШК(Команда)
	ОбработкаТабличнойЧастиТоварыКлиент.ВвестиШтрихкод(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеПоискаПоШтрихкоду(Штрихкод, ДополнительныеПараметры) Экспорт
	ИмяТЧ = "Товары";
	ИмяРеквизитаНоменклатуры = "Номенклатура";
	ИмяРеквизитаКоличества = "Количество";
	сабОперОбщегоНазначенияНаКлиенте.ОбработатьЗаполнениеПоШтрихкодуНаКлиенте(ЭтаФорма, ИмяТЧ, ИмяРеквизитаНоменклатуры, ИмяРеквизитаКоличества, Штрихкод);	
	РежимСканирования = Истина;
	Элементы.Товары.ТекущийЭлемент = Элементы.ТабличнаяЧастьКоличество;
	ТабличнаяЧастьНоменклатураПриИзменении(Неопределено);
КонецПроцедуры
#КонецОбласти

&НаКлиенте
Процедура ТабличнаяЧастьНоменклатураПриИзменении(Элемент)
	ТекДанные = Элементы.Товары.ТекущиеДанные;
	
	//Установим НДС
	Если ЗначениеЗаполнено(ТекДанные.Номенклатура) Тогда
		ТекРеквизиты = БюджетныйНаСервере.ВернутьРеквизиты(ТекДанные.Номенклатура, "СтавкаНДС, СтавкаНДС.Ставка");
		ТекДанные.СтавкаНДС = ТекРеквизиты.СтавкаНДС;
		
		//Установим вид цен и рассчитаем цены
		ТекДанные.ВидЦеныПоставщика = ЗаполнитьВидЦен(ТекДанные.Номенклатура, Объект.Предприятие, Объект.Подразделение, Объект.Контрагент, ?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДата()));
		ТекДанные.Цена = РассчитатьЦенуПоВидуЦен(ТекДанные.ВидЦеныПоставщика, ТекДанные.Номенклатура, Объект.Предприятие, Объект.Подразделение, Объект.Контрагент, ?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДата()));
	КонецЕсли;
	
	РассчитатьСумму();
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаполнитьВидЦен(Номенклатура, Предприятие, Подразделение, Контрагент, Дата)

	//Запрос = Новый Запрос;
	//Запрос.Текст = 
	//"ВЫБРАТЬ
	//|	ЦеныНоменклатурыСрезПоследних.ВидЦены
	//|ИЗ
	//|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	//|			&Период,
	//|			ВидЦены.ЦенаПоставщика
	//|				И ВидЦены.Поставщик = &Контрагент
	//|				И Предприятие = &Предприятие
	//|				И Номенклатура = &Номенклатура
	//|				И Подразделение = &Подразделение) КАК ЦеныНоменклатурыСрезПоследних";
	//Запрос.УстановитьПараметр("Период", Дата);
	//Запрос.УстановитьПараметр("Контрагент", Контрагент);
	//Запрос.УстановитьПараметр("Предприятие", Предприятие);
	//Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	//Запрос.УстановитьПараметр("Подразделение", Подразделение);
	//
	//Выборка = Запрос.Выполнить().Выбрать();
	//Пока Выборка.Следующий() Цикл
	//	Возврат Выборка.ВидЦены;
	//КонецЦикла;
	
	Возврат Справочники.ВидыЦен.ПустаяСсылка();
	
КонецФункции

&НаСервереБезКонтекста
Функция РассчитатьЦенуПоВидуЦен(ВидЦены, Номенклатура, Предприятие, Подразделение, Контрагент, Дата)

	//Запрос = Новый Запрос;
	//Запрос.Текст = 
	//"ВЫБРАТЬ
	//|	ЦеныНоменклатурыСрезПоследних.Цена КАК Цена
	//|ИЗ
	//|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	//|			&Период,
	//|			ВидЦены.ЦенаПоставщика
	//|				И ВидЦены.Поставщик = &Контрагент
	//|				И Предприятие = &Предприятие
	//|				И Номенклатура = &Номенклатура
	//|				И ВидЦены = &ВидЦены) КАК ЦеныНоменклатурыСрезПоследних";
	//Запрос.УстановитьПараметр("Период", Дата);
	//Запрос.УстановитьПараметр("Контрагент", Контрагент);
	//Запрос.УстановитьПараметр("Предприятие", Предприятие);
	//Запрос.УстановитьПараметр("Подразделение", Подразделение);
	//Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	//Запрос.УстановитьПараметр("ВидЦены", ВидЦены);
	//
	//Выборка = Запрос.Выполнить().Выбрать();
	//Пока Выборка.Следующий() Цикл
	//	Возврат Выборка.Цена;
	//КонецЦикла;
	
	Возврат 0;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьЦену(Команда)
	
	Для Каждого ТекДанные Из Объект.Товары Цикл		
		//Установим вид цен и рассчитаем цены
		ТекДанные.ВидЦеныПоставщика = ЗаполнитьВидЦен(ТекДанные.Номенклатура, Объект.Предприятие, Объект.Подразделение, Объект.Контрагент, ?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДата()));
		ТекДанные.Цена = РассчитатьЦенуПоВидуЦен(ТекДанные.ВидЦеныПоставщика, ТекДанные.Номенклатура, Объект.Предприятие, Объект.Подразделение, Объект.Контрагент, ?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДата()));
		
		//Установим НДС и артикул
		Если ЗначениеЗаполнено(ТекДанные.Номенклатура) Тогда
			ТекРеквизиты = БюджетныйНаСервере.ВернутьРеквизиты(ТекДанные.Номенклатура, "СтавкаНДС, СтавкаНДС.Ставка, Код");
			ТекДанные.СтавкаНДС = ТекРеквизиты.СтавкаНДС;
		КонецЕсли;
		
		ТекДанные.Сумма = ТекДанные.Количество * ТекДанные.Цена;
		
		//лишний запрос делаем
		ТекРеквизиты = БюджетныйНаСервере.ВернутьРеквизиты(ТекДанные.СтавкаНДС, "Ставка");
		Если НЕ ТекРеквизиты = Неопределено Тогда
			ТекДанные.СуммаНДС = ТекДанные.Сумма / ((100+ТекРеквизиты.Ставка)/100) * (ТекРеквизиты.Ставка/100);
		КонецЕсли;
		
		РассчитатьСумму();
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	КонтрагентПриИзмененииСервер();
	ДоговорПриИзменении(Неопределено);
КонецПроцедуры

&НаСервере
Процедура КонтрагентПриИзмененииСервер()
	
	РеквизитыДоговора = сабОперОбщегоНазначения.ПолучитьДоговорКонтрагентаПоУмолчанию(Объект.Контрагент, Объект.Организация);
	Объект.Договор = РеквизитыДоговора.Договор;
	Если Не ЗначениеЗаполнено(Объект.Организация) Тогда
		Объект.Организация = РеквизитыДоговора.Организация;	
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ТабличнаяЧастьСтавкаНДСПриИзменении(Элемент)
	РассчитатьСумму();
КонецПроцедуры


&НаКлиенте
Процедура ДоговорПриИзменении(Элемент)
		
	СчетВзаиморасчетов = БюджетныйНаСервере.ВернутьРеквизит(Объект.Договор, "СчетВзаиморасчетов");
	
	Если ЗначениеЗаполнено(СчетВзаиморасчетов) И НЕ ЗначениеЗаполнено(Объект.СчетКонтрагента) Тогда
		Объект.СчетКонтрагента = СчетВзаиморасчетов;
	КонецЕсли;
	
	Если Объект.СчетКонтрагента = УЧ_Сервер.СчетПоКоду("79.02") Тогда
		Объект.ПредприятиеВн = БюджетныйНаСервере.ВернутьРеквизит(Объект.Контрагент, "ПредприятиеХодлинга");
		Объект.ДоговорВн = БюджетныйНаСервере.ВернутьРеквизит(Объект.Договор, "ВнутрихолдинговыйДоговор");
		Элементы.ПодразделениеВн.Видимость = Истина;
		Элементы.ПредприятиеВн.Видимость = Истина;
		Элементы.ДоговорВн.Видимость = Истина;
	Иначе
		Элементы.ПодразделениеВн.Видимость = Ложь;
		Элементы.ПредприятиеВн.Видимость = Ложь;
		Элементы.ДоговорВн.Видимость = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

#Область ПодборТоваров

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборНоменклатуры.Форма.Форма" Тогда
		ОбработкаВыбораПодборВставкаИзБуфераНаСервере(ВыбранноеЗначение, ИсточникВыбора.ИмяТаблицы);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПодборТовары(Команда)

	ПараметрыПодбора = ПолучитьПараметрыПодбора("Товары");
	Если ПараметрыПодбора <> Неопределено Тогда
		ОткрытьФорму("Обработка.ПодборНоменклатуры.Форма.Форма", ПараметрыПодбора,
			ЭтаФорма, УникальныйИдентификатор);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбработкаВыбораПодборВставкаИзБуфераНаСервере(ВыбранноеЗначение, ИмяТаблицы)

	ЭтоВставкаИзБуфера = ВыбранноеЗначение.Свойство("ЭтоВставкаИзБуфера");
	СписокСвойств = Неопределено;
	Если ЭтоВставкаИзБуфера Тогда
		
		ТаблицаТоваров = ВыбранноеЗначение.Данные;
		СписокСвойств = ВыбранноеЗначение.СписокСвойств;
		
	Иначе
		
		ТаблицаТоваров = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресПодобраннойНоменклатурыВХранилище);
		
	КонецЕсли;
	
	ДанныеОбъекта = Новый Структура("Дата, Организация, Склад");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	ЗаполнитьСтавкиНДСВРознице = Ложь;
	
	СтрокиДляЗаполненияСчетов = Новый Массив;
	
	Для каждого СтрокаТовара Из ТаблицаТоваров Цикл
		
		СведенияОНоменклатуре = БюджетныйНаСервере.ВернутьРеквизиты(СтрокаТовара.Номенклатура, "ЕдиницаИзмерения, Счет10, СтавкаНДС");
		СтрокаТабличнойЧасти = Объект[ИмяТаблицы].Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаТовара, СписокСвойств);
		СтрокиДляЗаполненияСчетов.Добавить(СтрокаТабличнойЧасти);
		Если СведенияОНоменклатуре = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		//СтрокаТабличнойЧасти.СчетУчета		= ?(ЗначениеЗаполнено(СтрокаТабличнойЧасти.СчетУчета),
		//СтрокаТабличнойЧасти.СчетУчета, СведенияОНоменклатуре.Счет10);
	КонецЦикла;
	
	
	
	Если ЭтоВставкаИзБуфера Тогда
		
		ВыбранноеЗначение.КоличествоДобавленныхСтрок = СтрокиДляЗаполненияСчетов.Количество();
		
	КонецЕсли;
	

	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПараметрыПодбора(ИмяТаблицы)

	ДатаРасчетов		= ?(НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДата()),ТекущаяДата(), Объект.Дата);
	
	ЗаголовокПодбора	= НСтр("ru = 'Подбор номенклатуры в %1 (%2)'");
	Если ИмяТаблицы = "Товары" Тогда
		ПредставлениеТаблицы = НСтр("ru = 'Товары'");
	ИначеЕсли ИмяТаблицы = "ВозвратнаяТара" Тогда
		ПредставлениеТаблицы = НСтр("ru = 'Возвратная тара'");
	КонецЕсли;
	ЗаголовокПодбора = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ЗаголовокПодбора, Объект.Ссылка, ПредставлениеТаблицы);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ДатаРасчетов"  , ДатаРасчетов);
	ПараметрыФормы.Вставить("Валюта"        , ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());
	ПараметрыФормы.Вставить("Организация"   , Объект.Организация);
	ПараметрыФормы.Вставить("Подразделение" , Объект.Подразделение);
	ПараметрыФормы.Вставить("Склад"         , Объект.Склад);
	ПараметрыФормы.Вставить("Заголовок"     , ЗаголовокПодбора);
	ПараметрыФормы.Вставить("ВидПодбора"    , "");
	ПараметрыФормы.Вставить("ИмяТаблицы"    , ИмяТаблицы);
	ПараметрыФормы.Вставить("Услуги"        , ИмяТаблицы = "Услуги");
	ПараметрыФормы.Вставить("ПоказыватьОстатки"  , Истина);
	ПараметрыФормы.Вставить("ЕстьКоличество", Истина);
	ПараметрыФормы.Вставить("Предприятие" , Объект.Предприятие);
	
	Возврат ПараметрыФормы;

КонецФункции

#КонецОбласти 


#Область КомандыИзменения

&НаКлиенте
Процедура ПоказатьИзмененияВерсий(ИмяКоманды)

	СсылкаНаОбъект = ЭтаФорма.ДокументБУ; 
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Ссылка",СсылкаНаОбъект);
	СтруктураКоличествВерсий = сабОбщегоНазначенияБУХ.ПолучитьКоличествоВерсий(СсылкаНаОбъект);
	КолВерсий = СтруктураКоличествВерсий.КоличествоИзмененныхВерсий;
	СравниваемыеВерсии = Новый СписокЗначений;  
	Пока КолВерсий > 0 Цикл
		СравниваемыеВерсии.Добавить(СтруктураКоличествВерсий.КоличествоВерсий, СтруктураКоличествВерсий.КоличествоВерсий);
		СтруктураКоличествВерсий.КоличествоВерсий = СтруктураКоличествВерсий.КоличествоВерсий - 1;
		КолВерсий = КолВерсий - 1;
	КонецЦикла;
	ПараметрыОтчета.Вставить("СравниваемыеВерсии",СравниваемыеВерсии); 
	
	ОткрытьФорму("РегистрСведений.ВерсииОбъектов.Форма.ОтчетПоВерсиямОбъекта", ПараметрыОтчета);

КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьПоДокументу(ИмяКоманды)

	ПерезаполнитьДокументНаОснованиинаСервере();

КонецПроцедуры

&НаСервере
Процедура ПерезаполнитьДокументНаОснованиинаСервере()
	
	ТекОбъект = РеквизитФормыВЗначение("Объект");
	ТекОбъект.ОбработкаЗаполненияСФормы(ЭтаФорма.ДокументБУ, Неопределено, Истина);
	ЗначениеВРеквизитФормы(ТекОбъект, "Объект");
	
	//ОбновленнаяЗапись = РегистрыСведений.сабОбработкаДокументов.СоздатьМенеджерЗаписи();
	//ОбновленнаяЗапись.ДокументБУ = ЭтаФорма.ДокументБУ;
	//ОбновленнаяЗапись.ДокументУУ = Объект.Ссылка;
	//ОбновленнаяЗапись.ДатаОбработки = ТекущаяДата();
	//ОбновленнаяЗапись.Автор = ПараметрыСеанса.ТекущийПользователь;
	//ОбновленнаяЗапись.Модифицирован = Ложь;
	//ОбновленнаяЗапись.Записать();
	Элементы.ЭлементПерезаполнитьПоДокументу.Доступность = Ложь;
	
	ПриСозданииНаСервере(Ложь, Истина);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ОповеститьРегистрОбработанных", Новый Структура("ДокументУУ, ДокументБУ", Объект.Ссылка, ?(БюджетныйНаКлиенте.ЕстьСвойствоОбъекта(ЭтаФорма, "ДокументБУ"), ЭтаФорма.ДокументБУ, Неопределено)));	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элементы.Реализация.ТекущиеДанные.НесколькоСерий = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияНоменклатурыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекДанные = Элементы.Товары.ТекущиеДанные;
	Если ТекДанные.НесколькоСерий Тогда
		СтандартнаяОбработка = Ложь;
		ТекФорма = ПолучитьФорму("Документ.УЧ_Реализация.Форма.ФормаПодбораСерий");
		ТекФорма.Номенклатура = ТекДанные.Номенклатура;
		ТекФорма.Количество = ТекДанные.Количество;
		ТекФорма.НомерСтрокиРеализации = ТекДанные.НомерСтроки;
		Для каждого ТекСтрока Из Объект.СерииНоменклатуры Цикл
			Если ТекСтрока.Номенклатура = ТекДанные.Номенклатура И ТекСтрока.НомерСтрокиРеализации = ТекДанные.НомерСтроки Тогда
				НоваяСтрока = ТекФорма.СерииНоменклатуры.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
			КонецЕсли;
		КонецЦикла;
		ТекФорма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		Оп = Новый ОписаниеОповещения("ВыполнитьПослеОкончанияПодбора", ЭтотОбъект, Новый Структура);
		ТекФорма.ОписаниеОповещенияОЗакрытии = Оп;
		ТекФорма.Открыть();
	КонецЕсли;

КонецПроцедуры 

&НаКлиенте
Процедура ВыполнитьПослеОкончанияПодбора(Результат, Параметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекДанные = Элементы.Товары.ТекущиеДанные;
	МассивУдСерий = Новый Массив;
	Для каждого ТекСтрока Из Объект.СерииНоменклатуры Цикл
		Если ТекСтрока.Номенклатура = ТекДанные.Номенклатура И ТекСтрока.НомерСтрокиРеализации = ТекДанные.НомерСтроки Тогда
			МассивУдСерий.Добавить(ТекСтрока);
		КонецЕсли;
	КонецЦикла;
	
	Для каждого ТекУд Из МассивУдСерий Цикл
		Объект.СерииНоменклатуры.Удалить(ТекУд);
	КонецЦикла;
	
	НовоеКоличество = 0;
	Для каждого ТекСтрока Из Результат.СерииНоменклатуры Цикл
		НоваяСтрока = Объект.СерииНоменклатуры.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
		НоваяСтрока.НомерСтрокиРеализации = ТекДанные.НомерСтроки;
		НовоеКоличество = НовоеКоличество + ТекСтрока.Количество; 
		НоваяСтрока.ДатаПроизводства = сабОбщегоНазначенияБУХ.ПолучитьДатуПроизводстваДляСерииНоменклатуры(ТекСтрока.СерияНоменклатуры);
	КонецЦикла;
	
	ТекДанные.Количество = НовоеКоличество; 
	Объект.СерииНоменклатуры.Сортировать("НомерСтрокиРеализации");
	ТабличнаяЧастьКоличествоПриИзменении(Неопределено);

КонецПроцедуры


&НаКлиенте
Процедура ТоварыСерияНоменклатурыПриИзменении(Элемент)
	
	ТД = Элементы.Товары.ТекущиеДанные; 
	ПараметрыОтбораСерииНоменклатуры = Новый Структура("Номенклатура,НомерСтрокиРеализации",ТД.Номенклатура,ТД.НомерСтроки);
	МассивНайденныеСтрокиСерииНоменклатуры = Объект.СерииНоменклатуры.НайтиСтроки(ПараметрыОтбораСерииНоменклатуры);
	ИндексДляДобавления = Неопределено;
	Для каждого НайденнаяСтрокаСерииНоменклатуры Из МассивНайденныеСтрокиСерииНоменклатуры Цикл
		Если ИндексДляДобавления = Неопределено Тогда
			ИндексДляДобавления = Объект.СерииНоменклатуры.Индекс(НайденнаяСтрокаСерииНоменклатуры);
		КонецЕсли;
		Объект.СерииНоменклатуры.Удалить(НайденнаяСтрокаСерииНоменклатуры);
	КонецЦикла;
	Если ИндексДляДобавления = Неопределено Тогда
		 ИндексДляДобавления = 0;
	КонецЕсли;
	НоваяСтрокаСерииНоменклатуры = Объект.СерииНоменклатуры.Вставить(ИндексДляДобавления);
	НоваяСтрокаСерииНоменклатуры.Номенклатура = ТД.Номенклатура;
	НоваяСтрокаСерииНоменклатуры.Количество = ТД.Количество;
	НоваяСтрокаСерииНоменклатуры.НомерСтрокиРеализации = ТД.НомерСтроки;
	НоваяСтрокаСерииНоменклатуры.СерияНоменклатуры = ТД.СерияНоменклатуры;
	НоваяСтрокаСерииНоменклатуры.ДатаПроизводства = сабОбщегоНазначенияБУХ.ПолучитьДатуПроизводстваДляСерииНоменклатуры(ТД.СерияНоменклатуры);
	Объект.СерииНоменклатуры.Сортировать("НомерСтрокиРеализации");

КонецПроцедуры


&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Для Каждого СтрокаТЧ Из Объект.Товары Цикл
		НайденныеСерии = Объект.СерииНоменклатуры.НайтиСтроки(Новый Структура("Номенклатура, НомерСтрокиРеализации", СтрокаТЧ.Номенклатура, СтрокаТЧ.НомерСтроки));
		Если НайденныеСерии.Количество() > 1 Тогда
			СтрокаТЧ.НесколькоСерий = Истина;
			СтрокаТЧ.СерияНоменклатуры = Неопределено;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

