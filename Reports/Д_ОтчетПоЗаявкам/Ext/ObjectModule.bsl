﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	//КомпоновщикНастроек2 = Новый КомпоновщикНастроекКомпоновкиДанных;
	//КомпоновщикНастроек2.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	//КомпоновщикНастроек2.ЗагрузитьПользовательскиеНастройки(КомпоновщикНастроек.ПользовательскиеНастройки);
	
	НастройкиДляКомпоновкиМакета = КомпоновщикНастроек.ПолучитьНастройки();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиДляКомпоновкиМакета, ДанныеРасшифровки, Неопределено, Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, Неопределено, ДанныеРасшифровки, Истина);
	//Результат = Новый ТаблицаЗначений;
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	//ПроцессорВывода.УстановитьОбъект(Результат);
	Табл = ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
	СтандартнаяОбработка = Ложь;
	
	ЗаполнитьТаблицу(Табл);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицу(ВыбранныеДанныеТЗ)
	
	ИспользоватьНесколькоПредприятий = Константы.сабИспользоватьНесколькоПредприятий.Получить();
	
	Если Не ИспользоватьНесколькоПредприятий Тогда
		ОсновноеЦФО = ПараметрыСеанса.ТекущееПредприятие;
	КонецЕсли; 
	
	ТабДок.Очистить();
	
	Если ИспользоватьНесколькоПредприятий Тогда
		ВыбранныеДанныеТЗ.Свернуть("ИнвПроект, ИнвПроектКод, Подразделение, СтатьяДДС, СтатьяДДСКод, ЦФО", "Заявлено, Отклонение, План1, План2, План3, План4, ПланНаСогласовании, Факт, ФактВсего");
	Иначе
		ВыбранныеДанныеТЗ.Свернуть("ИнвПроект, ИнвПроектКод, Подразделение, СтатьяДДС, СтатьяДДСКод", "Заявлено, Отклонение, План1, План2, План3, План4, ПланНаСогласовании, Факт, ФактВсего");
	КонецЕсли;
	
	Макет = ЭтотОбъект.ПолучитьМакет("Макет");
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьЗаявкаБезналШапка = Макет.ПолучитьОбласть("ЗаявкаБезналШапка");
	//ОбластьЗаявкаБезнал = Макет.ПолучитьОбласть("ЗаявкаБезнал");
	ОбластьИтого = Макет.ПолучитьОбласть("Итого");
	ОбластьВсего = Макет.ПолучитьОбласть("Всего");
	ОбластьЗаявкаРасшифровка = Макет.ПолучитьОбласть("ЗаявкаРасшифровка");
	
	ТабДок.Вывести(ОбластьЗаголовок);
	
	Дата1 = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[0].Значение.ДатаНачала;
	Дата2 = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[0].Значение.ДатаОкончания;
	ИсключатьАвансовые = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[1].Значение;
	
	АктуальныйСценарийУтв = Ложь;    //Русаков	
	АктуальныйСценарий  = БюджетныйНаСервере.ПолучитьАктуальныйСценарий(Дата2, Ложь);	//бюджет Актуальный на конечную дату
	
	ГодовойБюджетУтв = Ложь;
	КвартальныйБюджетУтв = Ложь;
	МесячныйБюджетУтв = Ложь;
	
	Для Каждого СценарийБюджета Из ПолучитьВидыБюджетовНаДатуТек(Дата2) Цикл//МассивСценариевБюджета Цикл 
		
		Если ЗначениеЗаполнено(СценарийБюджета.Значение) Тогда		
			//Если СценарийБюджета = Справочники.СценарииПланирования.ПланПоСЗ  Тогда
			//	АктуальныйСценарийУтвержден = Истина                                         проверить!!!!
			//Иначе
			ПараметрыБюджета = БюджетныйНаСервере.ПолучитьПоследнююЗаписьПараметровБюджета(ОсновноеЦФО, СценарийБюджета.Значение);		
			Если ЗначениеЗаполнено(ПараметрыБюджета) Тогда
				Если СценарийБюджета.Значение.ВидБюджета = Перечисления.Д_ВидыБюджета.ГодовойБюджет и ПараметрыБюджета.Утвержден Тогда ГодовойБюджетУтв = Истина КонецЕсли; 
				Если СценарийБюджета.Значение.ВидБюджета = Перечисления.Д_ВидыБюджета.КвартальныйБюджет и ПараметрыБюджета.Утвержден Тогда КвартальныйБюджетУтв = Истина КонецЕсли;
				Если СценарийБюджета.Значение.ВидБюджета = Перечисления.Д_ВидыБюджета.МесячныйБюджет и ПараметрыБюджета.Утвержден Тогда МесячныйБюджетУтв = Истина КонецЕсли;
			КонецЕсли;		
			//КонецЕсли;	
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(АктуальныйСценарий) Тогда		
		Если АктуальныйСценарий = Справочники.СценарииПланирования.ПланПоСЗ  Тогда
			АктуальныйСценарийУтв = Истина
		Иначе
			ПараметрыБюджета = БюджетныйНаСервере.ПолучитьПоследнююЗаписьПараметровБюджета(ОсновноеЦФО, АктуальныйСценарий);		
			Если ЗначениеЗаполнено(ПараметрыБюджета) Тогда
				АктуальныйСценарийУтв = ПараметрыБюджета.Утвержден;
			КонецЕсли;		
		КонецЕсли;		
	КонецЕсли;
	
	
	ОбластьЗаявкаБезнал = Макет.ПолучитьОбласть("ЗаявкаБезнал|Область1");
	ОбластьЗаявкаБезнал2 = Макет.ПолучитьОбласть(?(ГодовойБюджетУтв,"ЗаявкаБезнал|Область2","ЗаявкаБезнал_НУ|Область2"));
	ОбластьЗаявкаБезнал3 = Макет.ПолучитьОбласть(?(КвартальныйБюджетУтв,"ЗаявкаБезнал|Область3","ЗаявкаБезнал_НУ|Область3"));
	ОбластьЗаявкаБезнал4 = Макет.ПолучитьОбласть(?(МесячныйБюджетУтв,"ЗаявкаБезнал|Область4","ЗаявкаБезнал_НУ|Область4"));       
	ОбластьЗаявкаБезнал5 = Макет.ПолучитьОбласть(?(АктуальныйСценарийУтв,"ЗаявкаБезнал|Область5","ЗаявкаБезнал_НУ|Область5"));  
	ОбластьЗаявкаБезнал6 = Макет.ПолучитьОбласть("ЗаявкаБезнал|Область6");
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	ТекущаяЗаявка.СтатьяДДС КАК СтатьяДДС,
	               |	ВЫБОР
	               |		КОГДА Д_ЗаявкаНаАвансовыйОтчетСтрокиЗаявкиНаОплату.Ссылка ЕСТЬ NULL
	               |			ТОГДА ЕСТЬNULL(ТекущаяЗаявка.СуммаДДС, 0)
	               |		ИНАЧЕ 0
	               |	КОНЕЦ КАК Заявлено,
	               |	ТекущаяЗаявка.ЦФО КАК ЦФО,
	               |	ТекущаяЗаявка.Ссылка КАК Регистратор,
	               |	ТекущаяЗаявка.Ссылка.Дата КАК ДатаЗаявки,
	               |	ТекущаяЗаявка.Основание КАК Основание,
	               |	ТекущаяЗаявка.Ссылка.Предприятие КАК Предприятие,
	               |	ТекущаяЗаявка.Ссылка.Представление КАК Представление,
	               |	ТекущаяЗаявка.Ссылка.Дата КАК Дата,
	               |	ТекущаяЗаявка.Ссылка.Номер КАК Номер,
	               |	ВЫБОР
	               |		КОГДА ПроверкаСостоянияДокумента.ЗаявкаНаФинансированиеАкцептован = ИСТИНА
	               |				И ПроверкаСостоянияДокумента.АКЦЕПТОВАН = 1
	               |			ТОГДА ""Акцептован""
	               |		КОГДА ПроверкаСостоянияДокумента.ЗаявкаНаФинансированиеАкцептован = ИСТИНА
	               |				И ПроверкаСостоянияДокумента.АКЦЕПТОВАН = 2
	               |			ТОГДА ""Частично акцептован""
	               |		КОГДА ВложенныйЗапрос.Ссылка.ТочкаМаршрута = ЗНАЧЕНИЕ(БизнесПроцесс.Согласование1.ТочкаМаршрута.Действие1)
	               |				ИЛИ ВложенныйЗапрос.Ссылка.ТочкаМаршрута ЕСТЬ NULL
	               |					И НЕ Согласование1.Завершен = ИСТИНА
	               |				ИЛИ Согласование1.Ссылка ЕСТЬ NULL
	               |			ТОГДА ""На подготовке""
	               |		КОГДА ВложенныйЗапрос.Ссылка.ТочкаМаршрута = ЗНАЧЕНИЕ(БизнесПроцесс.Согласование1.ТочкаМаршрута.Действие2)
	               |			ТОГДА ""На согласовании""
	               |		КОГДА ВложенныйЗапрос.Ссылка.ТочкаМаршрута = ЗНАЧЕНИЕ(БизнесПроцесс.Согласование1.ТочкаМаршрута.Действие3)
	               |			ТОГДА ""На проверке""
	               |		КОГДА ВложенныйЗапрос.Ссылка.ТочкаМаршрута = ЗНАЧЕНИЕ(БизнесПроцесс.Согласование1.ТочкаМаршрута.Действие4)
	               |			ТОГДА ""На результирующем согласовании""
	               |		КОГДА ВложенныйЗапрос.Ссылка.ТочкаМаршрута = ЗНАЧЕНИЕ(БизнесПроцесс.Согласование1.ТочкаМаршрута.Действие5)
	               |			ТОГДА ""На исполнении""
	               |		КОГДА ВложенныйЗапрос.Ссылка.ТочкаМаршрута = ЗНАЧЕНИЕ(БизнесПроцесс.Согласование1.ТочкаМаршрута.ПроверкаКонтрагентов)
	               |			ТОГДА ""Проверка контрагентов""
	               |		КОГДА Согласование1.Завершен = ИСТИНА
	               |			ТОГДА ВЫБОР
	               |					КОГДА ПроверкаСостоянияДокумента.СтрокОтменено > 0
	               |						ТОГДА ""Оплачено не полностью""
	               |					ИНАЧЕ ""Исполнено""
	               |				КОНЕЦ
	               |		ИНАЧЕ """"
	               |	КОНЕЦ КАК СостояниеДокумента,
	               |	ВЫБОР
	               |		КОГДА Согласование1.Завершен = ИСТИНА
	               |			ТОГДА ВЫБОР
	               |					КОГДА Д_ЗаявкаНаАвансовыйОтчетСтрокиЗаявкиНаОплату.Ссылка ЕСТЬ NULL
	               |						ТОГДА ЕСТЬNULL(ТекущаяЗаявка.СуммаДДС, 0)
	               |					ИНАЧЕ 0
	               |				КОНЕЦ
	               |		ИНАЧЕ 0
	               |	КОНЕЦ КАК ФактТекущаяЗаявка,
	               |	ТекущаяЗаявка.НазначениеПлатежа КАК НазначениеПлатежа,
	               |	ТекущаяЗаявка.Ссылка.ДатаОплаты КАК ДатаОплаты,
	               |	ВЫБОР
	               |		КОГДА ТекущаяЗаявка.ЦФО.УчетПоПодразделениям = ИСТИНА
	               |				ИЛИ ТекущаяЗаявка.ЦФО = &ПредприятиеКазна
	               |			ТОГДА ТекущаяЗаявка.Подразделение
	               |		ИНАЧЕ ""Основное""
	               |	КОНЕЦ КАК Подразделение,
	               |	ТекущаяЗаявка.ИнвПроект КАК ИнвПроект,
	               |	ВЫБОР
	               |		КОГДА Д_ЗаявкаНаАвансовыйОтчетСтрокиЗаявкиНаОплату.Ссылка ЕСТЬ NULL
	               |			ТОГДА ЕСТЬNULL(ТекущаяЗаявка.СуммаДДС, 0)
	               |		ИНАЧЕ 0
	               |	КОНЕЦ КАК ФактВсего,
	               |	ТекущаяЗаявка.Контрагент КАК Контрагент
	               |ИЗ
	               |	Документ.Д_ЗаявкаНаОплату.ЗаявкаБезнал КАК ТекущаяЗаявка
	               |		ЛЕВОЕ СОЕДИНЕНИЕ БизнесПроцесс.Согласование1 КАК Согласование1
	               |		ПО ТекущаяЗаявка.Ссылка = Согласование1.Заявка
	               |			И (Согласование1.ПометкаУдаления = ЛОЖЬ)
	               |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	               |			Задача.Заявка КАК Заявка,
	               |			МАКСИМУМ(Задача.Ссылка) КАК Ссылка
	               |		ИЗ
	               |			Задача.Задача КАК Задача
	               |		ГДЕ
	               |			Задача.ПометкаУдаления = ЛОЖЬ
	               |			И Задача.Выполнена = ЛОЖЬ
	               |		
	               |		СГРУППИРОВАТЬ ПО
	               |			Задача.Заявка) КАК ВложенныйЗапрос
	               |		ПО ТекущаяЗаявка.Ссылка = ВложенныйЗапрос.Заявка
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Д_ЗаявкаНаАвансовыйОтчет.СтрокиЗаявкиНаОплату КАК Д_ЗаявкаНаАвансовыйОтчетСтрокиЗаявкиНаОплату
	               |		ПО ТекущаяЗаявка.УИДСтроки = Д_ЗаявкаНаАвансовыйОтчетСтрокиЗаявкиНаОплату.УИДСтрокиДокОснования
	               |			И (НЕ ТекущаяЗаявка.УИДСтроки = """")
	               |			И (Д_ЗаявкаНаАвансовыйОтчетСтрокиЗаявкиНаОплату.Ссылка.ПометкаУдаления = ЛОЖЬ)
	               |			И ТекущаяЗаявка.Ссылка = Д_ЗаявкаНаАвансовыйОтчетСтрокиЗаявкиНаОплату.ДокОснование
	               |			И (НЕ &ИсключатьАвансовые)
	               |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	               |			Д_ЗаявкаНаОплатуЗаявкаБезнал.Ссылка КАК Ссылка,
	               |			МАКСИМУМ(Д_ЗаявкаНаОплатуЗаявкаБезнал.ЗаявкаНаФинансирование.Акцептован) КАК ЗаявкаНаФинансированиеАкцептован,
	               |			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
	               |					КОГДА Д_ЗаявкаНаОплатуЗаявкаБезнал.ЗаявкаНаФинансирование.Акцептован = ИСТИНА
	               |						ТОГДА ""1""
	               |					ИНАЧЕ ""0""
	               |				КОНЕЦ) КАК АКЦЕПТОВАН,
	               |			СУММА(ВЫБОР
	               |					КОГДА Д_ЗаявкаНаОплатуЗаявкаБезнал.ОтменаОплаты
	               |						ТОГДА 1
	               |					ИНАЧЕ 0
	               |				КОНЕЦ) КАК СтрокОтменено
	               |		ИЗ
	               |			Документ.Д_ЗаявкаНаОплату.ЗаявкаБезнал КАК Д_ЗаявкаНаОплатуЗаявкаБезнал
	               |		
	               |		СГРУППИРОВАТЬ ПО
	               |			Д_ЗаявкаНаОплатуЗаявкаБезнал.Ссылка) КАК ПроверкаСостоянияДокумента
	               |		ПО ТекущаяЗаявка.Ссылка = ПроверкаСостоянияДокумента.Ссылка
	               |ГДЕ
	               |	ТекущаяЗаявка.Ссылка.ПометкаУдаления = ЛОЖЬ
	               |	И ТекущаяЗаявка.ОтменаОплаты = ЛОЖЬ
	               |	И ВЫБОР
	               |			КОГДА ТекущаяЗаявка.Ссылка.ДатаОплаты < ТекущаяЗаявка.Ссылка.Дата
	               |				ТОГДА ТекущаяЗаявка.Ссылка.Дата
	               |			ИНАЧЕ ТекущаяЗаявка.Ссылка.ДатаОплаты
	               |		КОНЕЦ МЕЖДУ &ДатаНачала И &ДатаОкончания
	               |	И (ТекущаяЗаявка.Ссылка.Предприятие В (&Предприятия)
	               |			ИЛИ ТекущаяЗаявка.ЦФО В (&Предприятия)
	               |			ИЛИ ТекущаяЗаявка.Ссылка.Автор В (&Автор))
	               |	И НЕ ТекущаяЗаявка.СуммаДДС = 0
	               |	И ТекущаяЗаявка.ЦФО В(&ЦФО)
	               |	И Согласование1.НеСогласовано = ЛОЖЬ
	               |	И ЛОЖЬ
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	Д_ЗаявкаНаАвансовыйОтчетЗатраты.Статья,
	               |	Д_ЗаявкаНаАвансовыйОтчетЗатраты.Сумма,
	               |	Д_ЗаявкаНаАвансовыйОтчетЗатраты.Предприятие,
	               |	Д_ЗаявкаНаАвансовыйОтчетЗатраты.Ссылка,
	               |	Д_ЗаявкаНаАвансовыйОтчетЗатраты.Ссылка.Дата,
	               |	NULL,
	               |	Д_ЗаявкаНаАвансовыйОтчетЗатраты.Ссылка.Предприятие,
	               |	Д_ЗаявкаНаАвансовыйОтчетЗатраты.Ссылка.Представление,
	               |	Д_ЗаявкаНаАвансовыйОтчетЗатраты.Ссылка.Дата,
	               |	Д_ЗаявкаНаАвансовыйОтчетЗатраты.Ссылка.Номер,
	               |	ВЫБОР
	               |		КОГДА Д_ЗаявкаНаАвансовыйОтчетЗатраты.Ссылка.Проведен
	               |			ТОГДА ЗНАЧЕНИЕ(Перечисление.Д_СостоянияДокументов.Исполнен)
	               |		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.Д_СостоянияДокументов.НаСогласовании)
	               |	КОНЕЦ,
	               |	ВЫБОР
	               |		КОГДА Д_ЗаявкаНаАвансовыйОтчетЗатраты.Ссылка.ТекущийБизнесПроцесс.Завершен = ИСТИНА
	               |			ТОГДА Д_ЗаявкаНаАвансовыйОтчетЗатраты.Сумма
	               |		ИНАЧЕ 0
	               |	КОНЕЦ,
	               |	Д_ЗаявкаНаАвансовыйОтчетЗатраты.Описание,
	               |	NULL,
	               |	ВЫБОР
	               |		КОГДА Д_ЗаявкаНаАвансовыйОтчетЗатраты.Предприятие.УчетПоПодразделениям
	               |				ИЛИ Д_ЗаявкаНаАвансовыйОтчетЗатраты.Предприятие = &ПредприятиеКазна
	               |			ТОГДА Д_ЗаявкаНаАвансовыйОтчетЗатраты.Подразделение
	               |		ИНАЧЕ ""Основное""
	               |	КОНЕЦ,
	               |	Д_ЗаявкаНаАвансовыйОтчетЗатраты.ИнвПроект,
	               |	Д_ЗаявкаНаАвансовыйОтчетЗатраты.Сумма,
	               |	Д_ЗаявкаНаАвансовыйОтчетЗатраты.Ссылка.ПодотчетноеЛицо
	               |ИЗ
	               |	Документ.Д_ЗаявкаНаАвансовыйОтчет.Затраты КАК Д_ЗаявкаНаАвансовыйОтчетЗатраты
	               |ГДЕ
	               |	Д_ЗаявкаНаАвансовыйОтчетЗатраты.Ссылка.ПометкаУдаления = ЛОЖЬ
	               |	И Д_ЗаявкаНаАвансовыйОтчетЗатраты.Ссылка.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	               |	И Д_ЗаявкаНаАвансовыйОтчетЗатраты.Предприятие В(&Предприятия)
	               |	И НЕ &ИсключатьАвансовые
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	сабГрафикПлатежей.СтатьяДДС,
	               |	сабГрафикПлатежей.Сумма,
	               |	сабГрафикПлатежей.ЦФО,
	               |	сабГрафикПлатежей.Документ,
	               |	сабГрафикПлатежей.Документ.Дата,
	               |	NULL,
	               |	сабГрафикПлатежей.Предприятие,
	               |	сабГрафикПлатежей.Документ.Представление,
	               |	сабГрафикПлатежей.ДатаПлатежа,
	               |	сабГрафикПлатежей.Документ.Номер,
	               |	NULL,
	               |	сабГрафикПлатежей.Сумма,
	               |	сабГрафикПлатежей.НазначениеПлатежа,
	               |	сабГрафикПлатежей.ДатаПлатежа,
	               |	сабГрафикПлатежей.ПодразделениеЦФО,
	               |	сабГрафикПлатежей.ДопПризнак,
	               |	сабГрафикПлатежей.Сумма,
	               |	сабГрафикПлатежей.Контрагент
	               |ИЗ
	               |	РегистрСведений.сабГрафикПлатежей КАК сабГрафикПлатежей
	               |ГДЕ
	               |	сабГрафикПлатежей.ДатаПлатежа МЕЖДУ &ДатаНачала И &ДатаОкончания
	               |	И (сабГрафикПлатежей.Предприятие В (&Предприятия)
	               |			ИЛИ сабГрафикПлатежей.ЦФО В (&Предприятия)
	               |			ИЛИ сабГрафикПлатежей.Документ.Автор В (&Автор))
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ЦФО,
	               |	Дата";
	
	Запрос.УстановитьПараметр("ПредприятиеКазна", Константы.сабПредприятиеКазна.Получить());
	Запрос.УстановитьПараметр("ДатаНачала", Дата1);
	Запрос.УстановитьПараметр("ДатаОкончания", Дата2);
	Запрос.УстановитьПараметр("Автор", БПСервер.ПолучитьМассивПользователей());
	Запрос.УстановитьПараметр("ИсключатьАвансовые", ИсключатьАвансовые);
	
	Если ИспользоватьНесколькоПредприятий Тогда
		Запрос.УстановитьПараметр("ЦФО", ВыбранныеДанныеТЗ.ВыгрузитьКолонку("ЦФО"));
	Иначе
		Запрос.УстановитьПараметр("ЦФО", ОсновноеЦФО);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Предприятия", БюджетныйНаСервере.ПолучитьПредприятия());
	Запрос.УстановитьПараметр("ДоступностьПредприятия", Ложь);
	РезультатЗаявки = Запрос.Выполнить();
	
	СтруктураБюджетов = ПолучитьВидыБюджетовНаДатуТек(Дата1);
	
	ОбластьЗаявкаБезналШапка.Параметры.План1 = СтруктураБюджетов.ГодовойБюджет;
	ОбластьЗаявкаБезналШапка.Параметры.План2 = СтруктураБюджетов.КвартальныйБюджет;
	ОбластьЗаявкаБезналШапка.Параметры.План3 = СтруктураБюджетов.МесячныйБюджет;
	
	ТабДок.Вывести(ОбластьЗаявкаБезналШапка);
	
	НомерСтроки = 1;
	СуммаИтого = 0;
	СуммаВсего = 0;
	
	СуммаТекВыпИтого = 0;
	СуммаТекВыпВсего = 0;
	
	СуммаФактИтого = 0;
	СуммаФактВсего = 0;
	
	ТабДок.НачатьАвтогруппировкуСтрок();
	
	ТекПП = ?(ИспользоватьНесколькоПредприятий, Справочники.Предприятия.ПустаяСсылка(), ОсновноеЦФО);
	ТекПодр = Справочники.СтруктураПредприятия.ПустаяСсылка();
	
	Для каждого ВыборкаДанные Из ВыбранныеДанныеТЗ Цикл
		
		
		Если ПустаяСтрока(ТекПП) ИЛИ ПустаяСтрока(ТекПодр) Тогда
			
			Если ИспользоватьНесколькоПредприятий Тогда
				ТекПП = ВыборкаДанные.ЦФО;
			КонецЕсли; 
			
			ТекПодр = ВыборкаДанные.Подразделение;
		Иначе
			
			Если ?(ИспользоватьНесколькоПредприятий, НЕ ТекПП = ВыборкаДанные.ЦФО, Истина) ИЛИ НЕ ТекПодр = ВыборкаДанные.Подразделение Тогда
				ОбластьИтого.Параметры.ИтогоЗаявлено = СуммаИтого;
				ОбластьИтого.Параметры.ИтогоТекВып = СуммаТекВыпИтого;
				ОбластьИтого.Параметры.ИтогоФакт = СуммаФактИтого;
				ОбластьИтого.Параметры.ЦФО = ТекПП;
				ОбластьИтого.Параметры.Подразделение = ТекПодр;
				ТабДок.Вывести(ОбластьИтого, 0);
				СуммаИтого = 0;
				СуммаТекВыпИтого = 0;
				СуммаФактИтого = 0;
				ТекПП = ?(ИспользоватьНесколькоПредприятий, ВыборкаДанные.ЦФО, ОсновноеЦФО);
				ТекПодр = ВыборкаДанные.Подразделение;
			КонецЕсли;
			
		КонецЕсли;
		
		ОбластьЗаявкаБезнал.Параметры.Заполнить(ВыборкаДанные);
		ОбластьЗаявкаБезнал2.Параметры.Заполнить(ВыборкаДанные);
		ОбластьЗаявкаБезнал3.Параметры.Заполнить(ВыборкаДанные);
		ОбластьЗаявкаБезнал4.Параметры.Заполнить(ВыборкаДанные);
		ОбластьЗаявкаБезнал5.Параметры.Заполнить(ВыборкаДанные);
		ОбластьЗаявкаБезнал6.Параметры.Заполнить(ВыборкаДанные);
		ОбластьЗаявкаБезнал.Параметры.НомерСтроки = НомерСтроки;
		
		//расшифрока
		Если ИспользоватьНесколькоПредприятий Тогда
			СтруктураРасшифровкиПлан = Новый Структура("Сценарии, ЦФО, Подразделение, СтатьяДДС, ИнвПроект, Дата1, Дата2, Признак",
			СтруктураБюджетов, ВыборкаДанные.ЦФО, ВыборкаДанные.Подразделение,
			ВыборкаДанные.СтатьяДДС, ВыборкаДанные.ИнвПроект, Дата1, Дата2, "План");
			
			СтруктураРасшифровкиФакт = Новый Структура("Сценарии, ЦФО, Подразделение, СтатьяДДС, ИнвПроект, Дата1, Дата2, Признак",
			СтруктураБюджетов, ВыборкаДанные.ЦФО, ВыборкаДанные.Подразделение,
			ВыборкаДанные.СтатьяДДС, ВыборкаДанные.ИнвПроект, Дата1, Дата2, "Факт");
		Иначе
			СтруктураРасшифровкиПлан = Новый Структура("Сценарии, ЦФО, Подразделение, СтатьяДДС, ИнвПроект, Дата1, Дата2, Признак",
			СтруктураБюджетов, ТекПП, ВыборкаДанные.Подразделение,
			ВыборкаДанные.СтатьяДДС, ВыборкаДанные.ИнвПроект, Дата1, Дата2, "План");
			
			СтруктураРасшифровкиФакт = Новый Структура("Сценарии, ЦФО, Подразделение, СтатьяДДС, ИнвПроект, Дата1, Дата2, Признак",
			СтруктураБюджетов, ТекПП, ВыборкаДанные.Подразделение,
			ВыборкаДанные.СтатьяДДС, ВыборкаДанные.ИнвПроект, Дата1, Дата2, "Факт");			
		КонецЕсли; 
		
		ОбластьЗаявкаБезнал2.Параметры.РасшифровкаПлан = СтруктураРасшифровкиПлан;		
		ОбластьЗаявкаБезнал3.Параметры.РасшифровкаПлан = СтруктураРасшифровкиПлан;
		ОбластьЗаявкаБезнал4.Параметры.РасшифровкаПлан = СтруктураРасшифровкиПлан;
		ОбластьЗаявкаБезнал5.Параметры.РасшифровкаПлан = СтруктураРасшифровкиПлан;
		ОбластьЗаявкаБезнал6.Параметры.РасшифровкаПлан = СтруктураРасшифровкиПлан;
		ОбластьЗаявкаБезнал6.Параметры.РасшифровкаФакт = СтруктураРасшифровкиФакт;
		
		ТабДок.Вывести(ОбластьЗаявкаБезнал, 1);
		ТабДок.Присоединить(ОбластьЗаявкаБезнал2, 1);
		ТабДок.Присоединить(ОбластьЗаявкаБезнал3, 1);
		ТабДок.Присоединить(ОбластьЗаявкаБезнал4, 1);
		ТабДок.Присоединить(ОбластьЗаявкаБезнал5, 1);
		ТабДок.Присоединить(ОбластьЗаявкаБезнал6, 1);
		
		
		//выводим список заявок
		Если ИспользоватьНесколькоПредприятий Тогда
			СтруктураЗаявок = Новый Структура("СтатьяДДС, ЦФО, Подразделение, ИнвПроект", ВыборкаДанные.СтатьяДДС, ВыборкаДанные.ЦФО, ВыборкаДанные.Подразделение, ВыборкаДанные.ИнвПроект);
		Иначе
			СтруктураЗаявок = Новый Структура("СтатьяДДС, Подразделение, ИнвПроект", ВыборкаДанные.СтатьяДДС, ВыборкаДанные.Подразделение, ВыборкаДанные.ИнвПроект);
		КонецЕсли; 
		
		ВыборкаЗаявок = РезультатЗаявки.Выбрать();
		
		НомерЗаявки = 0; 
		
		ОстатокДС = ВыборкаДанные.План4;
		
		Пока ВыборкаЗаявок.НайтиСледующий(СтруктураЗаявок) Цикл
			НомерЗаявки = НомерЗаявки + 1;
			ОбластьЗаявкаРасшифровка.Параметры.Заполнить(ВыборкаЗаявок);		
			ОбластьЗаявкаРасшифровка.Параметры.НомерЗаявки = НомерЗаявки;
			ОбластьЗаявкаРасшифровка.Параметры.Заявлено = ВыборкаЗаявок.Заявлено - ВыборкаЗаявок.ФактТекущаяЗаявка;
			//ОбластьЗаявкаРасшифровка.Параметры.Заявлено = ВыборкаЗаявок.Заявлено - ВыборкаЗаявок.ФактТекущаяЗаявка;
			ОбластьЗаявкаРасшифровка.Параметры.Отклонение = ОстатокДС - ВыборкаЗаявок.Заявлено;
			ОстатокДС = ОстатокДС - ВыборкаЗаявок.Заявлено;
			
			//расшифровка
			СтруктураРасшифровки = Новый Структура;
			СтруктураРасшифровки.Вставить("Регистратор", ВыборкаЗаявок.Регистратор);
			//СтруктураРасшифровки.Вставить("НаПроверке", ?(ВыборкаЗаявок.СостояниеДокумента = НаПроверке, ВыборкаЗаявок.СостояниеДокумента, Неопределено));
			ОбластьЗаявкаРасшифровка.Параметры.РасшифровкаЗаявки = СтруктураРасшифровки;
			
			ТабДок.Вывести(ОбластьЗаявкаРасшифровка, 2, , Ложь);
		КонецЦикла; 
		
		НомерСтроки = НомерСтроки + 1;
		СуммаИтого = СуммаИтого + ВыборкаДанные.Заявлено;
		СуммаВсего = СуммаВсего + ВыборкаДанные.Заявлено;
		
		СуммаТекВыпИтого = СуммаТекВыпИтого + ВыборкаДанные.Факт;
		СуммаТекВыпВсего = СуммаТекВыпВсего + ВыборкаДанные.Факт;
		
		СуммаФактИтого = СуммаФактИтого + ОбластьЗаявкаБезнал6.Параметры.Факт + ОбластьЗаявкаБезнал6.Параметры.Заявлено;
		СуммаФактВсего = СуммаФактВсего + ОбластьЗаявкаБезнал6.Параметры.Факт + ОбластьЗаявкаБезнал6.Параметры.Заявлено;
		
	КонецЦикла;
	
	//итого последнее ПП в списке
	Если ВыбранныеДанныеТЗ.Количество() Тогда
		ОбластьИтого.Параметры.ИтогоЗаявлено = СуммаИтого;
		ОбластьИтого.Параметры.ИтогоТекВып = СуммаТекВыпИтого;
		ОбластьИтого.Параметры.ИтогоФакт = СуммаФактИтого;
		ОбластьИтого.Параметры.ЦФО = ТекПП;
		ОбластьИтого.Параметры.Подразделение = ТекПодр;
		ТабДок.Вывести(ОбластьИтого, 0);
		СуммаИтого = 0;
		ТекПП = ?(ИспользоватьНесколькоПредприятий, ВыборкаДанные.ЦФО, ОсновноеЦФО);
		ТекПодр = ВыборкаДанные.Подразделение;
	КонецЕсли;
	
	ТабДок.ЗакончитьАвтогруппировкуСтрок();	
	
	ОбластьВсего.Параметры.ВсегоЗаявлено = СуммаВсего;
	ОбластьВсего.Параметры.ВсегоТекВып = СуммаТекВыпВсего;
	ОбластьВсего.Параметры.ВсегоФакт = СуммаФактВсего;
	ТабДок.Вывести(ОбластьВсего);
	
	
	//таблицу на экран
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	ТабДок.ФиксацияСверху = 6; 
	//ТабДок.Показать();
	
КонецПроцедуры

&НаСервере
//возвращает структуру бюджетов на видам для текущей даты без учета УТВЕРЖДЕНИЯ
Функция ПолучитьВидыБюджетовНаДатуТек(ТекДата, Утвержден = Истина, ДатаОкончания = Неопределено) Экспорт    //Русаков
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	СценарииПланирования.Ссылка,
	|	СценарииПланирования.ВидБюджета
	|ИЗ
	|	Справочник.СценарииПланирования КАК СценарииПланирования
	|ГДЕ
	|	СценарииПланирования.ДатаНачала < &ТекДата
	|	И СценарииПланирования.ДатаКонца >= &ТекДата
	|	И НЕ СценарииПланирования.ВидБюджета = &ВидБюджета";
	
	Запрос.УстановитьПараметр("ТекДата", НачалоМесяца(ТекДата));
	Запрос.УстановитьПараметр("ВидБюджета", Перечисления.Д_ВидыБюджета.ВариантБюджета);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	ПустойБюджет = Справочники.СценарииПланирования.ПустаяСсылка();
	СтруктураБюджетов = Новый Структура("ГодовойБюджет, КвартальныйБюджет, МесячныйБюджет, КорректировочныйБюджет", ПустойБюджет, ПустойБюджет, ПустойБюджет, ПустойБюджет);
	Т = Перечисления.Д_ВидыБюджета.МесячныйБюджет.Метаданные();
	
	Пока Выборка.Следующий() Цикл
		
		//Если Утвержден Тогда
		//	
		//	Если Не ПБ_СценарийУтвержденТек(Выборка.Ссылка) Тогда
		//		Продолжить;
		//	КонецЕсли;
		//	
		//КонецЕсли;
		
		Если Не ПустаяСтрока(Выборка.ВидБюджета) Тогда
			СтруктураБюджетов[СтрЗаменить(Строка(Выборка.ВидБюджета), " ", "")] = Выборка.Ссылка;		
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СтруктураБюджетов;	
	
КонецФункции
