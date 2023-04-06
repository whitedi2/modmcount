﻿&НаСервере
Функция КоличествоСубконто(Счет)
	КолСубконто = Счет.ВидыСубконто.Количество();	
	Возврат КолСубконто;
КонецФункции

&НаКлиенте
Процедура ТабличнаяЧастьСубконто1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Кол = КоличествоСубконто(Элементы.ТабличнаяЧасть.ТекущиеДанные.СчетЗатрат);
	Если Кол < 1 Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьСубконто2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Кол = КоличествоСубконто(Элементы.ТабличнаяЧасть.ТекущиеДанные.СчетЗатрат);
	Если Кол < 2 Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьСубконто3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Кол = КоличествоСубконто(Элементы.ТабличнаяЧасть.ТекущиеДанные.СчетЗатрат);
	Если Кол < 3 Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)

КонецПроцедуры

&НаСервереБезКонтекста
Функция СчетТовары()
	Возврат ПланыСчетов.Учетный.Счет41()
КонецФункции

&НаСервере
Функция ДокМомент()
	Возврат Объект.Ссылка.МоментВремени();	
КонецФункции

&НаКлиенте
Процедура ТабличнаяЧастьТоварНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	//СтандартнаяОбработка = ЛОЖЬ;
	//Если Объект.Ссылка.Пустая() Тогда
	//	ДатаГраница = КонецДня(Объект.Дата)
	//Иначе
	//	ДатаГраница =  ДокМомент();
	//КонецЕсли;
	//Подр = Объект.Подразделение;
	//Тов = Элементы.ТабличнаяЧасть.ТекущиеДанные.Товар;
	//Парам = Новый Структура("ТекущаяСтрока, ВыбДата,ВыбСчет,ВыбПредприятие,ВыбПодразделение,ВыбСклад",Тов, ДатаГраница,СчетТовары(),Объект.Предприятие,Подр,Объект.Склад);
	//ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаВыбораСОстатками4143",Парам,Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ПредприятиеПриИзменении(Элемент)
	ПредприятиеПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПредприятиеПриИзмененииНаСервере()
	сабОбщегоНазначенияКлиентСервер.СкрытьПодразделения(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	БюджетныйНаСервере.ДействияПриСозданииФормыДокумента(ЭтаФорма);
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если ЗначениеЗаполнено(Объект.Подразделение) Тогда
			РеквизитыПодразделения = БюджетныйНаСервере.ВернутьРеквизиты(Объект.Подразделение, "Склад, Организация");
			//Объект.Склад = РеквизитыПодразделения.Склад;
			Объект.Организация = РеквизитыПодразделения.Организация;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Объект.Склад) Тогда
			Объект.Склад = сабОперОбщегоНазначения.ПолучитьСкладПоДопСвойству(ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Склад инвентаризаций (Склады)", Истина), Объект.Предприятие);	
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ТабличнаяЧастьЗаполнитьПоСкладуБрака.Заголовок = "Заполнить по складу инвентаризации товары (кроме алко)";
	Элементы.ТабличнаяЧастьЗаполнитьПоСкладуБракаАлко.Заголовок = "Заполнить по складу инвентаризации брака алко";
	
	
	//Если ЗначениеЗаполнено(Объект.Склад) И НЕ рольдоступна("сабУчетчик") Тогда
	//	Элементы.Склад.Доступность = Ложь;
	//КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЗаполнитьДобавленныеКолонкиТаблиц();
	КонецЕсли;
	
	СчетПриИзмененииНаСервере();
	
	ИспользоватьСерии = Справочники.СерииНоменклатуры.СерииНоменклатурыИспользуются();
	
КонецПроцедуры


&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	сабОбщегоНазначения.ОтобразитьСостояниеДокумента(ЭтаФорма);
	ЗаполнитьДобавленныеКолонкиТаблиц();
КонецПроцедуры


&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	сабОбщегоНазначения.ОтобразитьСостояниеДокумента(ЭтаФорма, ТекущийОбъект);
КонецПроцедуры

#Область ПоискПоШК

&НаКлиенте
Процедура ПодобратьНоменклатуруПоШК(Команда)
	ОбработкаТабличнойЧастиТоварыКлиент.ВвестиШтрихкод(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеПоискаПоШтрихкоду(Штрихкод, ДополнительныеПараметры) Экспорт
	
	ИмяТЧ = "ТабличнаяЧасть";
	ИмяРеквизитаНоменклатуры = "Товар";
	ИмяРеквизитаКоличества = "Количество";
	сабОперОбщегоНазначенияНаКлиенте.ОбработатьЗаполнениеПоШтрихкодуНаКлиенте(ЭтаФорма, ИмяТЧ, ИмяРеквизитаНоменклатуры, ИмяРеквизитаКоличества, Штрихкод);
	РежимСканирования = Истина;
	Элементы.ТабличнаяЧасть.ТекущийЭлемент = Элементы.ТабличнаяЧастьКоличество;
	ТабличнаяЧастьМатериалПриИзменении(Неопределено);

КонецПроцедуры


#КонецОбласти

&НаКлиенте
Процедура ТабличнаяЧастьМатериалПриИзменении(Элемент)
	
	ТекДанные = Элементы.ТабличнаяЧасть.ТекущиеДанные;
	Элементы.ТабличнаяЧасть.ТекущиеДанные.СчетУчета = сабОбщегоНазначения.ПолучитьСчетУчетаНоменклатуры(ТекДанные.Товар, Объект.Организация, Объект.Склад);
	ТабличнаяЧастьСчетЗатратПриИзменении(Неопределено);

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьРеквизитыСчетов(Номенклатура)
	РеквизитыНом = БюджетныйНаСервере.ВернутьРеквизиты(Номенклатура, "Счет10, ЕдиницаИзмерения");
	Возврат Новый Структура("Счет91, Статья91, СчетУчета", ПланыСчетов.Учетный.НайтиПоКоду("91"), Справочники.СтатьиДвиженияДенежныхСредств.НайтиПоНаименованию("Затраты на простой предприятия", Истина), РеквизитыНом.Счет10, РеквизитыНом.ЕдиницаИзмерения);
КонецФункции
	
&НаСервереБезКонтекста
Функция ПолучитьСубконто91()
	Возврат Справочники.СтатьиДвиженияДенежныхСредств.НайтиПоНаименованию("Затраты на простой предприятия", Истина);	
КонецФункции

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Для каждого ТекСтрока Из Объект.ТабличнаяЧасть Цикл
		Если ЗначениеЗаполнено(Объект.Счет) Тогда
			ТекСтрока.СчетЗатрат = Объект.Счет;
			ТекСтрока.Субконто1 = Объект.Субконто1;
			ТекСтрока.Субконто2 = Объект.Субконто2;
			ТекСтрока.Субконто3 = Объект.Субконто3;
		КонецЕсли;	
	КонецЦикла; 
КонецПроцедуры

&НаСервереБезКонтекста
Функция Статья91ПоУмолчанию()
	Возврат Справочники.СтатьиДоходовРасходов.НайтиПоНаименованию("Списание Брака", Истина);
КонецФункции // ()


&НаКлиенте
Процедура ВидДеятельностиПриИзменении(Элемент)
	ПодразделениеПриИзмененииСервер();
КонецПроцедуры

&НаСервере
Процедура ПодразделениеПриИзмененииСервер()
	Если ЗначениеЗаполнено(Объект.Подразделение) Тогда
		РеквизитыПодразделения = БюджетныйНаСервере.ВернутьРеквизиты(Объект.Подразделение, "Склад, Организация");
		//Если Объект.ВидОперации = Перечисления.ВидыОперацийСписания.СписаниеПодснятий Тогда
			Объект.Склад = сабОперОбщегоНазначения.ПолучитьСкладПоДопСвойству(ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Склад инвентаризаций (Склады)", Истина), Объект.Предприятие);	
			Элементы.ТабличнаяЧастьЗаполнитьПоСкладуБрака.Заголовок = "Заполнить по складу инвентаризации товары (кроме алко)";
			Элементы.ТабличнаяЧастьЗаполнитьПоСкладуБракаАлко.Заголовок = "Заполнить по инвентаризации подснятий брака алко";
		//Иначе
		//	Объект.Склад = сабОперОбщегоНазначения.ПолучитьСкладПоДопСвойству(ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Склад брака (Склады)", Истина));	
		//	Элементы.ТабличнаяЧастьЗаполнитьПоСкладуБрака.Заголовок = "Заполнить по складу брака товары (кроме алко)";
		//	Элементы.ТабличнаяЧастьЗаполнитьПоСкладуБракаАлко.Заголовок = "Заполнить по складу брака брака алко";
		//КонецЕсли;
		//Если ЗначениеЗаполнено(Объект.Склад) И НЕ рольдоступна("сабУчетчик") Тогда
		//	Элементы.Склад.Доступность = Ложь;
		//Иначе	
			Объект.Склад = РеквизитыПодразделения.Склад;
		//КонецЕсли;
		Объект.Организация = РеквизитыПодразделения.Организация;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьКоличествоПриИзменении(Элемент)
	
	Если РежимСканирования Тогда
		ПодобратьНоменклатуруПоШК(Неопределено);
		Элементы.ТабличнаяЧасть.ЗакончитьРедактированиеСтроки(Ложь);
	КонецЕсли;
	
	РассчитатьСумму();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоСкладуВозврата(Команда)
	Если Объект.ТабличнаяЧасть.Количество() Тогда
		ТекстВопроса = НСтр("ru = 'Табичная часть заполнена. Очистить?'");
		ОбработчикОповещения = Новый ОписаниеОповещения("ПодтверждениеВопроса", ЭтотОбъект, Новый Структура("ИмяКоманды", Команда.Имя));
		ПоказатьВопрос(ОбработчикОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ЗаполнитьПоСкладуВозвратаНаСервере(Команда.Имя);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПодтверждениеВопроса(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Объект.ТабличнаяЧасть.Очистить();
	КонецЕсли;
	ЗаполнитьПоСкладуВозвратаНаСервере(ДополнительныеПараметры.ИмяКоманды);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоСкладуВозвратаНаСервере(ИмяКоманды)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	УчетныйОстатки.Субконто1 КАК Товар,
	               |	-УчетныйОстатки.КоличествоОстаток КАК Количество,
	               |	УчетныйОстатки.Субконто1.Код КАК Артикул,
	               |	-УчетныйОстатки.СуммаОстаток КАК Сумма,
	               |	ВЫБОР
	               |		КОГДА УчетныйОстатки.КоличествоОстаток = 0
	               |			ТОГДА 0
	               |		ИНАЧЕ УчетныйОстатки.СуммаОстаток / УчетныйОстатки.КоличествоОстаток
	               |	КОНЕЦ КАК Цена
	               |ИЗ
	               |	РегистрБухгалтерии.Учетный.Остатки(
	               |			&Дата,
	               |			Счет В (&Счет41)
	               |				ИЛИ Счет В (&Счет43),
	               |			,
	               |			Субконто2 = &Склад
	               |				И Предприятия = &Предприятие
	               |				И Подразделение = &Подразделение
	               |				И ВЫРАЗИТЬ(Субконто1 КАК Справочник.Номенклатура) = &ЭтоАлко) КАК УчетныйОстатки
	               |ГДЕ
	               |	(УчетныйОстатки.КоличествоОстаток < 0
	               |			ИЛИ УчетныйОстатки.СуммаОстаток < 0)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Артикул";
	
	
	Запрос.УстановитьПараметр("Дата", ?(ЗначениеЗаполнено(Объект.Ссылка), Объект.Дата, ТекущаяДата()));
	Запрос.УстановитьПараметр("Склад", Объект.Склад);
	Запрос.УстановитьПараметр("Предприятие", Объект.Предприятие);
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.УстановитьПараметр("ЭтоАлко", ИмяКоманды  = "ЗаполнитьПоСкладуБракаАлко");
	Запрос.УстановитьПараметр("Счет41", ПланыСчетов.Учетный.Счет41());
	Запрос.УстановитьПараметр("Счет43", ПланыСчетов.Учетный.Счет43());
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Объект.ТабличнаяЧасть.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьСчетЗатратПриИзменении(Элемент)
	ПоляОбъекта = Новый Структура("Субконто1, Субконто2, Субконто3, Предприятие, Счет, Подразделение",
	"Субконто1", "Субконто2", "Субконто3", Объект.Предприятие, "СчетЗатрат", "КорПодразделение");
	
	БюджетныйНаКлиенте.УстановитьДоступность(Элементы.ТабличнаяЧасть.ТекущиеДанные, ПоляОбъекта);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ЗаполнитьДобавленныеКолонкиТаблиц();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДобавленныеКолонкиТаблиц()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	*,
	               |	ВЫБОР
	               |		КОГДА Учетный.Ссылка В ИЕРАРХИИ(&ДенежныеСчета)
	               |			ТОГДА ИСТИНА
	               |		ИНАЧЕ ЛОЖЬ
	               |	КОНЕЦ КАК ДенежныйСчет
	               |ИЗ
	               |	ПланСчетов.Учетный КАК Учетный
	               |ГДЕ
	               |	Учетный.Ссылка В(&Ссылка)";
	
	МассивСчетов1 = Объект.ТабличнаяЧасть.Выгрузить().ВыгрузитьКолонку("СчетЗатрат");			   
	

	Запрос.УстановитьПараметр("ДенежныеСчета", Новый Массив);
	Запрос.УстановитьПараметр("Ссылка", МассивСчетов1);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выгрузить();
	
	СтруктураДанныхСчета = Новый Структура;
	Для Каждого ТекСтрокаВыборки ИЗ Выборка Цикл
		Если ЗначениеЗаполнено(ТекСтрокаВыборки.Ссылка) Тогда
			СтруктураДанныхСчета.Вставить("Счет" + СтрЗаменить(ТекСтрокаВыборки.Код,".",""), ТекСтрокаВыборки);	
		КонецЕсли;
	КонецЦикла;
	
	ВедетсяВалютныйУчет = Объект.Предприятие.ВедетсяВалютныйУчет;
	Для Каждого СтрокаТаблицы Из Объект.ТабличнаяЧасть Цикл
		
		ПредставлениеСчетаДт = "Счет" + СтрЗаменить(Строка(СтрокаТаблицы.СчетЗатрат),".","");
		
		Если СтруктураДанныхСчета.Свойство(ПредставлениеСчетаДт) Тогда
			КоличествоСубконто   = СтруктураДанныхСчета[ПредставлениеСчетаДт].ВидыСубконто.Количество();
			Для Индекс = 1 По 3 Цикл
				СтрокаТаблицы["Субконто"   + Индекс + "Доступность"] = (Индекс <= КоличествоСубконто);
			КонецЦикла;
			Валютный = ?(ВедетсяВалютныйУчет, СтруктураДанныхСчета[ПредставлениеСчетаДт].Валютный, ?(СтруктураДанныхСчета[ПредставлениеСчетаДт].ДенежныйСчет, СтруктураДанныхСчета[ПредставлениеСчетаДт].Валютный, Ложь));
			ДоступностьУчетаПоПодразделениямДт = СтруктураДанныхСчета[ПредставлениеСчетаДт].УчетПоПодразделениям;	
			КоличественныйДт = СтруктураДанныхСчета[ПредставлениеСчетаДт].Количественный;
		Иначе
			Валютный = Ложь;
			ДоступностьУчетаПоПодразделениямДт = Ложь;
			КоличественныйДт = Ложь
		КонецЕсли;
		
		СтрокаТаблицы["КорПодразделениеДоступность"] = ДоступностьУчетаПоПодразделениямДт;
		
	КонецЦикла;

	

КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	ПодразделениеПриИзмененииСервер();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКорСчета(Команда)
	ТекДанные = Элементы.ТабличнаяЧасть.ТекущиеДанные;
	Если НЕ ТекДанные = Неопределено Тогда
		ТекКорСчет = ТекДанные.СчетЗатрат;
		ТекКорСуб1 = ТекДанные.Субконто1;
		ТекКорСуб2 = ТекДанные.Субконто2;
		ТекКорСуб3 = ТекДанные.Субконто3;
		ТекКорПодр = ТекДанные.КорПодразделение;
		
		Для каждого ТекСтрока Из Объект.ТабличнаяЧасть Цикл
			Если НЕ ЗначениеЗаполнено(ТекСтрока.СчетЗатрат) Тогда
				ТекСтрока.СчетЗатрат = ТекКорСчет; 
				ТекСтрока.Субконто1 = ТекКорСуб1;
				ТекСтрока.Субконто2 = ТекКорСуб2;
				ТекСтрока.Субконто3 = ТекКорСуб3;
			   	ТекСтрока.КорПодразделение = ТекКорПодр;			
			КонецЕсли;	
		КонецЦикла; 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоИнвентаризации(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.ДокОснование) Или Не ТипЗнч(Объект.ДокОснование) = Тип("ДокументСсылка.УЧ_Инвентаризация") Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Не указан документ основания, либо документ основания не является инвентаризацией!";
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;	
	
	ЗаполнитьПоИнвентаризацииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоИнвентаризацииНаСервере(ЭтоАлко = Ложь)
	
	Объект.ТабличнаяЧасть.Очистить();
	
	Для Каждого СтрокаТЧ Из Объект.ДокОснование.Товары Цикл
		Если СтрокаТЧ.КоличествоОтклонение > 0 Или (СтрокаТЧ.КоличествоОтклонение = 0 И СтрокаТЧ.СуммаОтклонение > 0) Тогда
			Если ЭтоАлко Тогда
				Если НЕ СтрокаТЧ.Номенклатура.АлкогольнаяПродукция Тогда //только алко
					Продолжить;			
				КонецЕсли;
			Иначе
				Если СтрокаТЧ.Номенклатура.АлкогольнаяПродукция Тогда //все кроме алко
					Продолжить;			
				КонецЕсли;
			КонецЕсли;
			СтрокаТЧСписания = Объект.ТабличнаяЧасть.Добавить();
			СтрокаТЧСписания.Товар = СтрокаТЧ.Номенклатура;
			СтрокаТЧСписания.Количество = СтрокаТЧ.КоличествоОтклонение;
			СтрокаТЧСписания.Сумма = СтрокаТЧ.СуммаОтклонение;
			СтрокаТЧСписания.Цена = ?(СтрокаТЧ.КоличествоОтклонение = 0, 0, СтрокаТЧ.СуммаОтклонение/СтрокаТЧ.КоличествоОтклонение);
		КонецЕсли;
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоИнвентаризацииАлко(Команда)
	ЗаполнитьПоИнвентаризацииНаСервере(Истина);
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

	ПараметрыПодбора = ПолучитьПараметрыПодбора("ТабличнаяЧасть");
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
		СтрокаТабличнойЧасти.Товар = СтрокаТовара.Номенклатура;
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

&НаКлиенте
Процедура ТабличнаяЧастьЦенаПриИзменении(Элемент)
	
	РассчитатьСумму();	
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСумму(ТекДанные = Неопределено, ИмяТЧ = Неопределено, ПересчитыватьСумму = Истина)
	
	Если ТекДанные = Неопределено Тогда
		ТекДанные = Элементы.ТабличнаяЧасть.ТекущиеДанные;
	КонецЕсли;
	
	Если Не ТекДанные = Неопределено Тогда
		ТекДанные.Сумма = ТекДанные.Количество * ТекДанные.Цена;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти 

&НаКлиенте
Процедура СчетПриИзменении(Элемент)
	СчетПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура СчетПриИзмененииНаСервере()
	
	ДанныеСчета = УправленческийУчетПовтИсп.ПолучитьСвойстваСчета(Объект.Счет, Объект.Предприятие);
	
	Наименование1 = ДанныеСчета["ВидСубконто1Наименование"];
	Наименование2 = ДанныеСчета["ВидСубконто2Наименование"];
	Наименование3 = ДанныеСчета["ВидСубконто3Наименование"];
	УчетПоПодразделениям = ДанныеСчета["УчетПоПодразделениям"];
	
	Элементы.Субконто1.ПодсказкаВвода = Наименование1;
	Элементы.Субконто2.ПодсказкаВвода = Наименование2;
	Элементы.Субконто3.ПодсказкаВвода = Наименование3;
	Элементы.КорПодразделение.ПодсказкаВвода = ?(УчетПоПодразделениям, "Подразделение доходов", "");
	
	Элементы.Субконто1.Видимость = ЗначениеЗаполнено(Наименование1);
	Элементы.Субконто2.Видимость = ЗначениеЗаполнено(Наименование2);
	Элементы.Субконто3.Видимость = ЗначениеЗаполнено(Наименование3);
	Элементы.КорПодразделение.Видимость = УчетПоПодразделениям;
	
КонецПроцедуры


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


