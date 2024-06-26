﻿
&НаКлиенте
Процедура УУ_ОбработкаВыбораВместо(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.ДополнительныеОтчетыИОбработки.Форма.РазмещениеВРазделах") Тогда
		
		Если ТипЗнч(ВыбранноеЗначение) <> Тип("СписокЗначений") Тогда
			Возврат;
		КонецЕсли;
		
		Объект.Разделы.Очистить();
		Для Каждого ЭлементСписка Из ВыбранноеЗначение Цикл
			НоваяСтрока = Объект.Разделы.Добавить();
			НоваяСтрока.Раздел = ЭлементСписка.Значение; 
			НоваяСтрока.УУ_РазделРасш = ЭлементСписка.Значение; 
		КонецЦикла;
		
		Модифицированность = Истина;
		УстановитьВидимостьДоступность();
		
	ИначеЕсли ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.ДополнительныеОтчетыИОбработки.Форма.БыстрыйДоступКДополнительнымОтчетамИОбработкам") Тогда
		
		Если ТипЗнч(ВыбранноеЗначение) <> Тип("СписокЗначений") Тогда
			Возврат;
		КонецЕсли;
		
		ЭлементКоманда = Объект.Команды.НайтиПоИдентификатору(КлиентскийКэш.ИдентификаторСтрокиКоманды);
		Если ЭлементКоманда = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Найденные = БыстрыйДоступ.НайтиСтроки(Новый Структура("ИдентификаторКоманды", ЭлементКоманда.Идентификатор));
		Для Каждого СтрокаТаблицы Из Найденные Цикл
			БыстрыйДоступ.Удалить(СтрокаТаблицы);
		КонецЦикла;
		
		Для Каждого ЭлементСписка Из ВыбранноеЗначение Цикл
			СтрокаТаблицы = БыстрыйДоступ.Добавить();
			СтрокаТаблицы.ИдентификаторКоманды = ЭлементКоманда.Идентификатор;
			СтрокаТаблицы.Пользователь = ЭлементСписка.Значение;
		КонецЦикла;
		
		ЭлементКоманда.БыстрыйДоступПредставление = ПредставлениеБыстрогоДоступаПользователей(ВыбранноеЗначение.Количество());
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УУ_РазмещениеКомандНажатиеВместо(Элемент, СтандартнаяОбработка)	
	СтандартнаяОбработка = Ложь;
	Если Объект.Вид = ВидДополнительныйОтчет ИЛИ Объект.Вид = ВидДополнительнаяОбработка Тогда
		// Выбор разделов
		Разделы = Новый СписокЗначений;
		Для Каждого СтрокаТаблицы Из Объект.Разделы Цикл
			Разделы.Добавить(СтрокаТаблицы.УУ_РазделРасш);
		КонецЦикла;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Разделы",      Разделы);
		ПараметрыФормы.Вставить("ВидОбработки", Объект.Вид);
		
		ОткрытьФорму("Справочник.ДополнительныеОтчетыИОбработки.Форма.РазмещениеВРазделах", ПараметрыФормы, ЭтотОбъект);
	Иначе
		// Выбор объектов метаданных
		ПараметрыФормы = ПодготовитьПараметрыФормыВыборОбъектовМетаданных();
		ОткрытьФорму("ОбщаяФорма.ВыборОбъектовМетаданных", ПараметрыФормы);
	КонецЕсли;
КонецПроцедуры

&НаСервере
&Вместо("УстановитьВидимостьДоступность")
Процедура УУ_УстановитьВидимостьДоступность(Регистрация)
	
	ЭтоГлобальнаяОбработка = (Объект.Вид = ВидДополнительнаяОбработка ИЛИ Объект.Вид = ВидДополнительныйОтчет);
	ЭтоОтчет = (Объект.Вид = ВидДополнительныйОтчет ИЛИ Объект.Вид = ВидОтчет);
	
	Если Не Регистрация И Не ЭтоНовый И ЭтоОтчет Тогда
		ВариантыДополнительногоОтчетаЗаполнить();
	Иначе
		ВариантыДополнительногоОтчета.Очистить();
	КонецЕсли;
	
	КоличествоВариантов = ВариантыДополнительногоОтчета.Количество();
	КоличествоКоманд = Объект.Команды.Количество();
	КоличествоВидимыхЗакладок = 1;
	
	Если Объект.Вид = ВидДополнительныйОтчет И Объект.ИспользуетХранилищеВариантов Тогда
		КоличествоВидимыхЗакладок = КоличествоВидимыхЗакладок + 1;
		
		Элементы.СтраницыВарианты.Видимость = Истина;
		
		Если Регистрация ИЛИ КоличествоВариантов = 0 Тогда
			Элементы.СтраницыВарианты.ТекущаяСтраница = Элементы.ВариантыСкрытьДоЗаписи;
			Элементы.СтраницаВарианты.Заголовок = НСтр("ru = 'Варианты отчета'");
		Иначе
			Элементы.СтраницыВарианты.ТекущаяСтраница = Элементы.ВариантыПоказать;
			Элементы.СтраницаВарианты.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Варианты отчета (%1)'"),
				Формат(КоличествоВариантов, "ЧГ="));
		КонецЕсли;
	Иначе
		Элементы.СтраницыВарианты.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.СтраницаКоманды.Видимость = КоличествоКоманд > 0;
	Если КоличествоКоманд = 0 Тогда
		Элементы.СтраницаКоманды.Заголовок = НазваниеСтраницыКоманд();
	Иначе
		КоличествоВидимыхЗакладок = КоличествоВидимыхЗакладок + 1;
		Элементы.СтраницаКоманды.Заголовок = НазваниеСтраницыКоманд() + " (" + Формат(КоличествоКоманд, "ЧГ=") + ")";
	КонецЕсли;
	
	Элементы.ВыполнитьКоманду.Видимость = Ложь;
	Если ЭтоГлобальнаяОбработка И КоличествоКоманд > 0 Тогда
		Для Каждого СтрокаТаблицыКоманд Из Объект.Команды Цикл
			Если СтрокаТаблицыКоманд.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.ОткрытиеФормы")
				Или СтрокаТаблицыКоманд.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.ВызовКлиентскогоМетода")
				Или СтрокаТаблицыКоманд.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.ВызовСерверногоМетода")
				Или СтрокаТаблицыКоманд.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.СценарийВБезопасномРежиме") Тогда
				Элементы.ВыполнитьКоманду.Видимость = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	КоличествоРазрешений = РазрешенияПрофиляБезопасности().Количество();
	РежимСовместимостиРазрешений = Объект.РежимСовместимостиРазрешений;
	
	БезопасныйРежим = Объект.БезопасныйРежим;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПрофилиБезопасности") Тогда
		МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
		ИспользуютсяПрофилиБезопасности = МодульРаботаВБезопасномРежиме.ИспользуютсяПрофилиБезопасности();
	Иначе
		ИспользуютсяПрофилиБезопасности = Ложь;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("РаботаВМоделиСервиса") Или ИспользуютсяПрофилиБезопасности Тогда
		МодульРаботаВБезопасномРежимеСлужебный = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежимеСлужебный");
		Если РежимСовместимостиРазрешений = Перечисления.РежимыСовместимостиРазрешенийДополнительныхОтчетовИОбработок.Версия_2_1_3 Тогда
			Если БезопасныйРежим И КоличествоРазрешений > 0 И ИспользуютсяПрофилиБезопасности Тогда
				Если ЭтоНовый Тогда
					БезопасныйРежим = "";
				Иначе
					БезопасныйРежим = МодульРаботаВБезопасномРежимеСлужебный.РежимПодключенияВнешнегоМодуля(Объект.Ссылка);
				КонецЕсли;
			КонецЕсли;
		Иначе
			Если КоличествоРазрешений = 0 Тогда
				БезопасныйРежим = Истина;
			Иначе
				Если ИспользуютсяПрофилиБезопасности Тогда
					Если ЭтоНовый Тогда
						БезопасныйРежим = "";
					Иначе
						БезопасныйРежим = МодульРаботаВБезопасномРежимеСлужебный.РежимПодключенияВнешнегоМодуля(Объект.Ссылка);
					КонецЕсли;
				Иначе
					БезопасныйРежим = Ложь;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если КоличествоРазрешений = 0 Тогда
		
		Элементы.СтраницаРазрешения.Видимость = Ложь;
		Элементы.ГруппаБезопасныйРежимГлобальный.Видимость = Истина;
		Элементы.ДекорацияБезопасныйРежимЛожьНадпись.Видимость = (БезопасныйРежим = Ложь);
		Элементы.ДекорацияБезопасныйРежимИстинаНадпись.Видимость = (БезопасныйРежим = Истина);
		Элементы.ГруппаВключениеПрофилейБезопасности.Видимость = Ложь;
		
	Иначе
		
		КоличествоВидимыхЗакладок = КоличествоВидимыхЗакладок + 1;
		
		Элементы.СтраницаРазрешения.Видимость = Истина;
		Элементы.СтраницаРазрешения.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Разрешения (%1)'"),
			Формат(КоличествоРазрешений, "ЧГ="));
		
		Элементы.ГруппаБезопасныйРежимГлобальный.Видимость = Ложь;
		
		Элементы.ГруппаСтраницыРежимыСовместимостиРазрешений.ТекущаяСтраница = Элементы.СтраницаРазрешенияВерсия_2_2_2;
		
		Если БезопасныйРежим = Истина Тогда
			Элементы.СтраницыБезопасныйРежимСРазрешениями.ТекущаяСтраница = Элементы.СтраницаБезопасныйРежимСРазрешениями;
		ИначеЕсли БезопасныйРежим = Ложь Тогда
			Элементы.СтраницыБезопасныйРежимСРазрешениями.ТекущаяСтраница = Элементы.СтраницаНебезопасныйРежимСРазрешениями;
		ИначеЕсли ТипЗнч(БезопасныйРежим) = Тип("Строка") Тогда
			Элементы.СтраницыБезопасныйРежимСРазрешениями.ТекущаяСтраница = Элементы.СтраницаПерсональныйПрофильБезопасности;
			Элементы.ДекорацияПерсональныйПрофильБезопасностиНадпись.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Дополнительный отчет или обработка будет подключаться к программе с использованием ""персонального""
					|профиля безопасности %1, в котором будут разрешены только следующие операции:'"),
				БезопасныйРежим);
		Иначе
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 не является корректным режимом подключения для дополнительных отчетов и обработок,
					|требующих разрешений на использование профилей безопасности.'"),
				БезопасныйРежим);
		КонецЕсли;
		
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПрофилиБезопасности") Тогда
			МодульРаботаВБезопасномРежимеСлужебный = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежимеСлужебный");
			ДоступнаНастройкаПрофилейБезопасности = МодульРаботаВБезопасномРежимеСлужебный.ДоступнаНастройкаПрофилейБезопасности();
		Иначе
			ДоступнаНастройкаПрофилейБезопасности = Ложь;
		КонецЕсли;
		
		Если БезопасныйРежим = Ложь И Не ИспользуютсяПрофилиБезопасности И ДоступнаНастройкаПрофилейБезопасности Тогда
			Элементы.ГруппаВключениеПрофилейБезопасности.Видимость = Истина;
		Иначе
			Элементы.ГруппаВключениеПрофилейБезопасности.Видимость = Ложь;
		КонецЕсли;
		
		СформироватьСписокРазрешений();
		
	КонецЕсли;
	
	Элементы.СтраницыВариантыКомандыРазрешения.ОтображениеСтраниц = ОтображениеСтраницФормы[?(КоличествоВидимыхЗакладок > 1, "ЗакладкиСверху", "Нет")];
	
	ПредставлениеНазначения = "";
	Если ЭтоГлобальнаяОбработка Тогда
		Для Каждого СтрокаРаздел Из Объект.Разделы Цикл
			ПредставлениеРаздела = ДополнительныеОтчетыИОбработки.ПредставлениеРаздела(СтрокаРаздел.УУ_РазделРасш);
			Если ПредставлениеРаздела = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			ПредставлениеНазначения = ?(ПустаяСтрока(ПредставлениеНазначения), ПредставлениеРаздела,
				ПредставлениеНазначения + ", " + ПредставлениеРаздела);
		КонецЦикла;
	Иначе
		Для Каждого СтрокаНазначение Из Объект.Назначение Цикл
			ПредставлениеОбъекта = ДополнительныеОтчетыИОбработки.ПредставлениеОбъектаМетаданных(СтрокаНазначение.ОбъектНазначения);
			ПредставлениеНазначения = ?(ПустаяСтрока(ПредставлениеНазначения), ПредставлениеОбъекта,
				ПредставлениеНазначения + ", " + ПредставлениеОбъекта);
		КонецЦикла;
	КонецЕсли;
	Если ПредставлениеНазначения = "" Тогда
		ПредставлениеНазначения = НСтр("ru = 'Не определено'");
	КонецЕсли;
	
	Элементы.ОбъектКомандыБыстрыйДоступПредставление.Видимость       = ЭтоГлобальнаяОбработка;
	Элементы.ОбъектКомандыНастроитьБыстрыйДоступ.Видимость           = ЭтоГлобальнаяОбработка;
	Элементы.ОбъектКомандыРегламентноеЗаданиеПредставление.Видимость = ЭтоГлобальнаяОбработка;
	Элементы.ОбъектКомандыРегламентноеЗаданиеИспользование.Видимость = ЭтоГлобальнаяОбработка;
	Элементы.ОбъектКомандыНастроитьРасписание.Видимость              = ЭтоГлобальнаяОбработка;
	
	ЭтоПечатнаяФорма = Объект.Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.ПечатнаяФорма;
	Элементы.ТипыФорм.Видимость = Не ЭтоГлобальнаяОбработка И Не ЭтоПечатнаяФорма;
	Если Не Элементы.ТипыФорм.Видимость Тогда
		Объект.ИспользоватьДляФормыОбъекта = Истина;
		Объект.ИспользоватьДляФормыСписка = Истина;
	КонецЕсли;
	Элементы.НастроитьВидимость.Видимость = ЭтоПечатнаяФорма;
	Элементы.ОбъектКомандыКомментарий.Видимость = ЭтоПечатнаяФорма;
	
	Если ЭтоНовый Тогда
		Заголовок = ?(ЭтоОтчет, НСтр("ru = 'Дополнительный отчет (создание)'"), НСтр("ru = 'Дополнительная обработка (создание)'"));
	Иначе
		Заголовок = Объект.Наименование + " " + ?(ЭтоОтчет, НСтр("ru = '(Дополнительный отчет)'"), НСтр("ru = '(Дополнительная обработка)'"));
	КонецЕсли;
	
	Если КоличествоВариантов > 0 Тогда
		
		ВыводитьЗаголовокТаблицы = КоличествоВидимыхЗакладок <= 1 И Объект.Вид = ВидДополнительныйОтчет И Объект.ИспользуетХранилищеВариантов;
		
		Элементы.ВариантыДополнительногоОтчета.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы[?(ВыводитьЗаголовокТаблицы, "Верх", "Нет")];
		Элементы.ВариантыДополнительногоОтчета.Шапка               = НЕ ВыводитьЗаголовокТаблицы;
		Элементы.ВариантыДополнительногоОтчета.ГоризонтальныеЛинии = НЕ ВыводитьЗаголовокТаблицы;
		
	КонецЕсли;
	
	Если КоличествоКоманд > 0 Тогда
		
		ВыводитьЗаголовокТаблицы = КоличествоВидимыхЗакладок <= 1 И НЕ ЭтоГлобальнаяОбработка;
		
		Элементы.ОбъектКоманды.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы[?(ВыводитьЗаголовокТаблицы, "Верх", "Нет")];
		Элементы.ОбъектКоманды.Шапка               = НЕ ВыводитьЗаголовокТаблицы;
		Элементы.ОбъектКоманды.ГоризонтальныеЛинии = НЕ ВыводитьЗаголовокТаблицы;
		
	КонецЕсли;
	
	КлючСохраненияПоложенияОкна = ДополнительныеОтчетыИОбработки.ВидВСтроку(Объект.Вид);

КонецПроцедуры

&НаСервере
Процедура УУ_ПриСозданииНаСервереПеред(Отказ, СтандартнаяОбработка)
	
	Для Каждого ТекСтрокаРаздел Из Объект.Разделы Цикл
		
		Если Не ЗначениеЗаполнено(ТекСтрокаРаздел.УУ_РазделРасш) Тогда
			ТекСтрокаРаздел.УУ_РазделРасш = ТекСтрокаРаздел.Раздел;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры
