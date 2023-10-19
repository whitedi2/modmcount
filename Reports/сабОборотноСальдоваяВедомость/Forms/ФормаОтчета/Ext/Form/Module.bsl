﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	
	Отчет = Форма.Отчет;
	
	ЗаголовокОтчета = "Оборотно-сальдовая ведомость" + СтандартныеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Отчет.НачалоПериода, Отчет.КонецПериода);

	Если ЗначениеЗаполнено(Отчет.Организация) Тогда
		ЗаголовокОтчета = ЗаголовокОтчета + " " + УправленческийУчетПовтИсп.ПолучитьТекстОрганизация(Отчет.Организация, Ложь) 
						  + ?(БПСервер.ПолучитьКонстантуНаСервере("МодульВалютныеПроекты"), " (" + БюджетныйНаСервере.ВернутьРеквизит(Форма.Отчет.Организация, "ОсновнаяВалютаУчета") + ")", "");
	КонецЕсли;
	
	Форма.Заголовок = ЗаголовокОтчета;

КонецПроцедуры

&НаКлиенте
Функция ПолучитьЗапрещенныеПоля(Режим = "") Экспорт
	
	СписокПолей = Новый Массив;
	
	СписокПолей.Добавить("UserFields");
	СписокПолей.Добавить("DataParameters");
	СписокПолей.Добавить("SystemFields");
	СписокПолей.Добавить("Показатели");
	СписокПолей.Добавить("Период");
	
	Если Режим = "Выбор" Тогда
		Для Каждого ДоступноеПоле Из Отчет.КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы Цикл
			Если ДоступноеПоле.Ресурс Тогда
				СписокПолей.Добавить(Строка(ДоступноеПоле.Поле));
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если Режим = "Выбор" Тогда
		СписокПолей.Добавить("СальдоНаНачалоПериода");
		СписокПолей.Добавить("ОборотыЗаПериод");
		СписокПолей.Добавить("СальдоНаКонецПериода");
	ИначеЕсли Режим = "Отбор" Тогда
		СтандартныеОтчетыКлиент.ДобавитьПоляРесурсовВЗапрещенныеПоля(ЭтаФорма, СписокПолей);
	КонецЕсли;
	
	Возврат Новый ФиксированныйМассив(СписокПолей);
	
КонецФункции

&НаСервере
Процедура СформироватьОтчетСервер() Экспорт
	
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат;
	КонецЕсли;
	
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьЗаголовок", ВыводитьЗаголовок);
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьПодвал"   , ВыводитьПодвал);
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("СкрыватьНастройкиПриФормированииОтчета", СкрыватьНастройкиПриФормированииОтчета);
	
	Отч = РеквизитФормыВЗначение("Отчет");
	СтруктураПараметровОтчета = Новый Структура;
	СтруктураПараметровОтчета.Вставить("КомпоновщикНастроек", Неопределено);
	СтруктураПараметровОтчета.Вставить("КомпоновщикНастроекНастройки", Отчет.КомпоновщикНастроек.Настройки);
	СтруктураПараметровОтчета.Вставить("ДополнительныеПоля", Отчет.ДополнительныеПоля.Выгрузить());
	СтруктураПараметровОтчета.Вставить("РазвернутоеСальдо", Отчет.РазвернутоеСальдо.Выгрузить());
	СтруктураПараметровОтчета.Вставить("ИмяОтчета", "сабОборотноСальдоваяВедомость");
	СтруктураПараметровОтчета.Вставить("Группировка", Отчет.Группировка.Выгрузить());
	//СтруктураПараметровОтчета.Вставить("Отчет", Отч);
	Для каждого ТекЭл Из Метаданные.Отчеты.сабОборотноСальдоваяВедомость.Реквизиты Цикл
		СтруктураПараметровОтчета.Вставить(ТекЭл.Имя, Отчет[ТекЭл.Имя]);	
	КонецЦикла;
	НаборПоказателей2 = Новый Структура;
	НаборПоказателей2.Вставить("БУ", Метаданные.Отчеты.сабОборотноСальдоваяВедомость.Реквизиты.ПоказательБУ.Синоним);
	НаборПоказателей2.Вставить("ВалютнаяСумма", Метаданные.Отчеты.сабОборотноСальдоваяВедомость.Реквизиты.ПоказательВалютнаяСумма.Синоним);
	//НаборПоказателей2.Вставить("Количество", Метаданные.Отчеты.сабОборотноСальдоваяВедомость.Реквизиты.ПоказательКоличество.Синоним);
	//НаборПоказателей2.Вставить("Крахмал", Метаданные.Отчеты.сабОборотноСальдоваяВедомость.Реквизиты.ПоказательКрахмал.Синоним);
	//НаборПоказателей2.Вставить("Цена", Метаданные.Отчеты.сабОборотноСальдоваяВедомость.Реквизиты.ПоказательЦена.Синоним);
	//НаборПоказателей2.Вставить("Курс", Метаданные.Отчеты.сабОборотноСальдоваяВедомость.Реквизиты.ПоказательКурс.Синоним);
	СтруктураПараметровОтчета.Вставить("НаборПоказателей", НаборПоказателей2);
	СтруктураПараметровОтчета.Вставить("ИдентификаторОбъекта", "ОтчетОбъект.сабОборотноСальдоваяВедомость");
	
	Схема = Отчеты.сабОборотноСальдоваяВедомость.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	ПараметрыОтчета = Новый Структура("ОтчетОбъект, Результат, ДанныеРасшифровки, Схема, ВыводитьПолностью", СтруктураПараметровОтчета , Результат, ДанныеРасшифровки, Отч.СхемаКомпоновкиДанных, Истина);	
	
	
	РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
	УникальныйИдентификатор,
	"сабОбщегоНазначения.ВывестиТиповойОтчет",
	ПараметрыОтчета,
	НСтр("ru = 'Формирование отчета'"));
	
	АдресХранилища       = РезультатВыполнения.АдресХранилища;
	ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
	ЗаданиеВыполнено 	 = РезультатВыполнения.ЗаданиеВыполнено;

	//БухгалтерскийУчетПовтИсп.ВывестиОтчет(СтруктураПараметровОтчета, Результат, ДанныеРасшифровки, СхемаКомпоновкиДанных, Истина);
	//ОбъектОтчет = РеквизитФормыВЗначение("Отчет");
	//ОбъектОтчет.СформироватьОтчет(Результат, ДанныеРасшифровки, СхемаКомпоновкиДанных, Истина);
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНастройкамиПоУмолчанию(ЗаполняемыеНастройки) Экспорт
	
	Если ЗаполняемыеНастройки.Свойство("Показатели") Тогда
		Если ЗаполняемыеНастройки.Показатели Тогда
			// Управление показателями
			Отчет.ПоказательБУ            = Истина;
			//Отчет.ПоказательНУ            = Ложь;
			//Отчет.ПоказательПР            = Ложь;
			//Отчет.ПоказательВР            = Ложь;
			//Отчет.ПоказательКонтроль      = Ложь;
			Отчет.ПоказательВалютнаяСумма = Ложь;
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	//СтандартныеОтчетыКлиентСервер.ОбновитьПредставлениеПериода(Форма, Форма.Отчет.НачалоПериода, Форма.Отчет.КонецПериода);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ОчиститьСообщения();
	СформироватьОтчетСервер();
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	
	ПроверитьВыполнениеЗадания();
	ПодключитьОбработчикОжидания("ПроверитьВыполнениеЗадания", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВыполнениеЗадания()
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			ЗагрузитьПодготовленныеДанные();
			Заголовок = СтрЗаменить(Заголовок, " (формируется...)", "");
			УправленческиеОтчетыКлиентСервер.СкрыватьНастройкиПриФормированииОтчета(ЭтаФорма);
			Элементы.ПанельНастроек.Пометка = Элементы.ГруппаПанельНастроек.Видимость;
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		Иначе
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
			Заголовок = СтрЗаменить(Заголовок, " (формируется...)", "");
			Заголовок = Заголовок + " (формируется...)";
			ПодключитьОбработчикОжидания("ПроверитьВыполнениеЗадания", 0.1, Истина);
		КонецЕсли;
	Исключение
		ЗагрузитьПодготовленныеДанные();
		Заголовок = СтрЗаменить(Заголовок, " (формируется...)", "");
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	КонецПопытки;	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()
	Если Не ЗначениеЗаполнено(АдресХранилища) Тогда
		Возврат;	
	КонецЕсли;
	СтруктураПараметровОтчета = ПолучитьИзВременногоХранилища(АдресХранилища);
	Результат = СтруктураПараметровОтчета.Результат;
	//БухгалтерскийУчетПовтИсп.ВывестиОтчет(СтруктураПараметровОтчета.ОтчетОбъект, Результат, ДанныеРасшифровки, СхемаКомпоновкиДанных, Истина);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции


&НаКлиенте
Процедура ПанельНастроек(Команда)
	
	Элементы.ГруппаПанельНастроек.Видимость = Не Элементы.ГруппаПанельНастроек.Видимость;
	Элементы.ПанельНастроек.Пометка = Элементы.ГруппаПанельНастроек.Видимость;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

//&НаКлиенте
//Процедура ВидПериодаПриИзменении(Элемент)
//	
//	СтандартныеОтчетыКлиент.ВидПериодаПриИзменении(ЭтаФорма, Отчет.НачалоПериода, Отчет.КонецПериода, 
//		ДоступныеПериодыОтчета.День);
//	
//	ОбновитьТекстЗаголовка(ЭтаФорма);
//	
//	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
//	
//КонецПроцедуры

//&НаКлиенте
//Процедура ПериодПриИзменении(Элемент)
//	
//	СтандартныеОтчетыКлиент.ПериодПриИзменении(ЭтаФорма, Отчет.НачалоПериода, Отчет.КонецПериода, Элемент);
//	
//	ОбновитьТекстЗаголовка(ЭтаФорма);
//	
//	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
//	
//КонецПроцедуры

//&НаКлиенте
//Процедура ПериодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
//	
//	СтандартныеОтчетыКлиент.ВыбратьПроизвольныйПериодОтчета(ЭтаФорма, Отчет.НачалоПериода, Отчет.КонецПериода, 
//		ДоступныеПериодыОтчета.День);
//		
//	ОбновитьТекстЗаголовка(ЭтаФорма);
//	
//	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
//	
//КонецПроцедуры

//&НаКлиенте
//Процедура ПериодНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
//	
//	СтандартныеОтчетыКлиент.ПериодНачалоВыбораИзСписка(ЭтаФорма, Отчет.НачалоПериода, Отчет.КонецПериода,
//		Элемент, СтандартнаяОбработка);
//	
//	ОбновитьТекстЗаголовка(ЭтаФорма);
//	
//	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
//	
//КонецПроцедуры

//&НаКлиенте
//Процедура ПериодОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
//	
//	СтандартныеОтчетыКлиент.ПериодОбработкаВыбора(ЭтаФорма, Отчет.НачалоПериода, Отчет.КонецПериода, 
//		Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
//		
//	ОбновитьТекстЗаголовка(ЭтаФорма);
//	
//	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
//	
//КонецПроцедуры

//&НаКлиенте
//Процедура ПериодАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
//	
//	СтандартныеОтчетыКлиент.ПериодАвтоПодбор(ЭтаФорма, Отчет.НачалоПериода, Отчет.КонецПериода, Элемент, Текст, 
//		ДанныеВыбора, Ожидание, СтандартнаяОбработка);
//	
//КонецПроцедуры

//&НаКлиенте
//Процедура ПериодОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
//	
//	СтандартныеОтчетыКлиент.ПериодОкончаниеВводаТекста(ЭтаФорма, Отчет.НачалоПериода, Отчет.КонецПериода, Элемент, Текст, 
//		ДанныеВыбора, СтандартнаяОбработка);
//	
//КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	Отчет.ЭквивалентнаяВалюта = БюджетныйНаСервере.ВернутьРеквизит(Отчет.Организация, "ОсновнаяВалютаУчета");
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартныеОтчетыКлиент.ОбработкаРасшифровкиСтандартногоОтчета(ЭтаФорма, Элемент, Расшифровка, СтандартнаяОбработка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ПОКАЗАТЕЛИ

&НаКлиенте
Процедура ПоказательБУПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательНУПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательПРПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательВРПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательКонтрольПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательВалютнаяСуммаПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ГРУППИРОВКА

&НаКлиенте
Процедура ПоСубсчетамПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПриИзменении(Элемент)

	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	СтандартныеОтчетыКлиент.ТабличноеПолеПоСчетамГруппировкаПередНачаломДобавления(ЭтаФорма, "Группировка", Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаСчетПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиент.ТабличноеПолеПоСчетамСчетПриИзменении(ЭтаФорма, "Группировка", Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПоСубсчетамПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиент.ТабличноеПолеПоСчетамПоСубсчетамПриИзменении(ЭтаФорма, "Группировка", Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартныеОтчетыКлиент.ТабличноеПолеПоСчетамПредставлениеНачалоВыбора(ЭтаФорма, "Группировка", Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартныеОтчетыКлиент.ТабличноеПолеПоСчетамПредставлениеОчистка(ЭтаФорма, "Группировка", Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПредставлениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартныеОтчетыКлиент.ТабличноеПолеПоСчетамПредставлениеОбработкаВыбора(ЭтаФорма, "Группировка", Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаСнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.Группировка Цикл
		СтрокаТаблицы.Использование = Ложь;
	КонецЦикла;
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.Группировка Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла;
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ РАЗВЕРНУТОЕ САЛЬДО

&НаКлиенте
Процедура РазвернутоеСальдоПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутоеСальдоПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	СтандартныеОтчетыКлиент.ТабличноеПолеПоСчетамГруппировкаПередНачаломДобавления(ЭтаФорма, "РазвернутоеСальдо", Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутоеСальдоСчетПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиент.ТабличноеПолеПоСчетамСчетПриИзменении(ЭтаФорма, "РазвернутоеСальдо", Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутоеСальдоПоСубсчетамПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиент.ТабличноеПолеПоСчетамПоСубсчетамПриИзменении(ЭтаФорма, "РазвернутоеСальдо", Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутоеСальдоПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартныеОтчетыКлиент.ТабличноеПолеПоСчетамПредставлениеНачалоВыбора(ЭтаФорма, "РазвернутоеСальдо", Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутоеСальдоПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартныеОтчетыКлиент.ТабличноеПолеПоСчетамПредставлениеОчистка(ЭтаФорма, "РазвернутоеСальдо", Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутоеСальдоПредставлениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартныеОтчетыКлиент.ТабличноеПолеПоСчетамПредставлениеОбработкаВыбора(ЭтаФорма, "РазвернутоеСальдо", Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутоеСальдоСнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.РазвернутоеСальдо Цикл
		СтрокаТаблицы.Использование = Ложь;
	КонецЦикла;
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутоеСальдоУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.РазвернутоеСальдо Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла;
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ДОПОЛНИТЕЛЬНЫЕ ПОЛЯ

&НаКлиенте
Процедура РазмещениеДополнительныхПолейПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	СтандартныеОтчетыКлиент.ДополнительныеПоляПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломИзменения(Элемент, Отказ)
	
	СтандартныеОтчетыКлиент.ДополнительныеПоляПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляСнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.ДополнительныеПоля Цикл
		СтрокаТаблицы.Использование = Ложь;
	КонецЦикла;
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.ДополнительныеПоля Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла;
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ОТБОРЫ

&НаКлиенте
Процедура ОтборыПриИзменении(Элемент)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	СтандартныеОтчетыКлиент.ОтборыПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);

КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломИзменения(Элемент, Отказ)
	
	СтандартныеОтчетыКлиент.ОтборыПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ОФОРМЛЕНИЕ

&НаКлиенте
Процедура МакетОформленияПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиентСервер.УстановитьПараметрВывода(Отчет.КомпоновщикНастроек.Настройки, "МакетОформления", МакетОформления);
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьЗаголовокПриИзменении(Элемент)

	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ВыводитьПодвалПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УправленческийУчетПовтИсп.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	Если Параметры.Свойство("ИДРасшифровки") Тогда
		БюджетныйНаСервере.ДействияПриСозданииФормыДокумента(ЭтаФорма);
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Отчет.НачалоПериода = Отчет.Период.ДатаНачала;
	Отчет.КонецПериода  = Отчет.Период.ДатаОкончания;
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	ВариантМодифицирован                    = Ложь;
	ПользовательскиеНастройкиМодифицированы = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	УправленческийУчетПовтИсп.ПриСохраненииПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
	УправленческийУчетПовтИсп.ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	
	БюджетныйНаСервере.ДействияПриСозданииФормыДокумента(ЭтаФорма);
	
	УправлениеФормой(ЭтаФорма);
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
		
КонецПроцедуры


&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	Отчет.НачалоПериода = Отчет.Период.ДатаНачала;
	Отчет.КонецПериода = Отчет.Период.ДатаОкончания;
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	ИтогоСумма = Формат(БюджетныйНаКлиенте.Просуммировать(Результат), "ЧДЦ=2");
	
	
КонецПроцедуры

&НаКлиенте
Процедура Сумма(Команда)
    БюджетныйНаКлиенте.КопироватьВБуфер(ИтогоСумма);
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаДополнительнойРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	
	Расшифровка = Неопределено;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНастройки()
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьЗаголовок", ВыводитьЗаголовок);
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьПодвал"   , ВыводитьПодвал);
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("СкрыватьНастройкиПриФормированииОтчета", СкрыватьНастройкиПриФормированииОтчета);
КонецПроцедуры

&НаКлиенте
Процедура СкрыватьНастройкиПриФормированииОтчетаПриИзменении(Элемент)
	ОбновитьНастройки();
КонецПроцедуры

